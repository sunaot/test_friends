require 'resolv'

module TestFriends
  module ResolvErrorStub
    def force_resolv_error &block
      original_resolver = ::Resolv::DefaultResolver
      replace_resolver ErrorResolv.new
      begin
        block.call
      ensure
        replace_resolver original_resolver
      end
    end
    alias_method :force_resolve_error, :force_resolv_error
  
    private
    def replace_resolver new_resolver
      current = $VERBOSE
      $VERBOSE = nil # to ignore const redefined warning
      ::Resolv.const_set(:DefaultResolver, new_resolver)
      $VERBOSE = current
    end
  
    class ErrorResolv
      PublicAPIs = ::Resolv.new.public_methods(false)
      def raise_error *args
        raise ::Resolv::ResolvError
      end
     
      PublicAPIs.each {|method| alias_method method, :raise_error }
      private :raise_error
    end
  end
end
