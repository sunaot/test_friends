require 'tempfile'
require 'tmpdir'
require 'pathname'
require 'fileutils'
require 'forwardable'

module TestFriends
  class Tempfile
    extend Forwardable
    def_delegators '@path',
      *%w(
        basename dirname extname parent
        open read close sysopen truncate
        atime mtime ctime utime
        exist? file? directory? symlink? zero? ftype stat
        chmod chown delete unlink mkpath mkdir rename rmtree
        to_s
        )

    def initialize options = {}
      opt = { :extname => nil, :filename => nil, }.merge(options)
      dir = Dir.mktmpdir
      if opt[:filename] then
        file = create_tempfile_by_name dir, opt[:filename]
      elsif opt[:extname] then
        file = create_tempfile_with_extname dir, opt[:extname]
      else
        file = create_tempfile dir
      end
      ObjectSpace.define_finalizer self, Destructor.new(dir)
      @path = Pathname.new file.path
      @tempfile = file
      @dir = Pathname.new dir
    end

    def to_path
      @path
    end

    def touch mtime = Time.now, nocreate = false
      FileUtils.touch self.to_s, { :mtime => mtime, :nocreate => nocreate }
    end

    def teardown
      @tempfile.close!
      @dir.rmtree if @dir.exist?
      ObjectSpace.undefine_finalizer self
    end

    private
    def create_tempfile tmpdir
      ::Tempfile.new('', tmpdir)
    end

    def create_tempfile_by_name tmpdir, filename
      new_file = Pathname.new(tmpdir) + filename
      FileUtils.touch new_file.to_s
      behave_like_tempfile new_file
      new_file
    end

    def create_tempfile_with_extname tmpdir, extname
      ::Tempfile.new([nil, extname], tmpdir)
    end

    def behave_like_tempfile path
      ObjectSpace.define_finalizer path, Tempfile.destructor(path)
      class << path
        def path
          self.to_path
        end

        def close!
          self.delete if self.exist?
          ObjectSpace.undefine_finalizer self
        end
      end
    end

    def Tempfile.destructor path
      proc { path.delete if path.exist? }
    end

    class Destructor
      def initialize dirname
        @pid = Process.pid
        @dir = Pathname.new dirname
      end

      def call *args
        return if @pid != Process.pid
        STDERR.print "removing ", @dir.to_s, "..." if $DEBUG
        begin
          @dir.rmtree
        rescue Errno::ENOENT
        end
        STDERR.print "done\n" if $DEBUG
      end
    end
  end
end
