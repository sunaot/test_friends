require 'minitest/autorun'
require 'test_friends/resolv_error_stub'

class ResolvErrorStubTest < Minitest::Test
  include TestFriends::ResolvErrorStub

  def test_force_resolv_error
    force_resolv_error do
      assert_raises(Resolv::ResolvError) { Resolv.getaddresses 'www.example.com' }
    end
  end
end
