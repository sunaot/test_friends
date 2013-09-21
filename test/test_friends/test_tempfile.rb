require 'minitest/autorun'
require 'test_friends/tempfile'
require 'time'

class TempfileTest < Minitest::Test
  def setup
    @file = TestFriends::Tempfile.new
  end

  def teardown
    @file.teardown
  end

  def test_create_with_filename
    file = TestFriends::Tempfile.new :filename => 'sample.file'
    assert_equal('sample.file', file.basename.to_s)
  end

  def test_create_with_extname
    file = TestFriends::Tempfile.new :extname => '.md'
    assert_equal('.md', file.extname)
  end

  def test_create_with_no_option
    assert @file.file?
  end

  def test_write_file
    @file.open('w') {|f| f.write('hello, world') }
    assert_equal 'hello, world', @file.read
  end

  def test_remove_parent_dir
    @file.parent.rmtree
    assert !@file.exist?
  end

  def test_set_mtime
    a_time = Time.parse('2013/09/22 18:14:30')
    @file.utime a_time, a_time
    assert_equal 22, @file.mtime.day
  end

  def test_set_mtime_by_touch
    @file.touch Time.parse('2013/09/22 18:14:30')
    assert_equal 22, @file.mtime.day
  end
end
