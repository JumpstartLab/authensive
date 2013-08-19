require './test/test_helper'

module Authensive
  class UserTest < Minitest::Test

    def test_it_exists
      assert User
    end

    def test_it_creates_users
      assert_equal 0, User.count
      user = User.create(:name => "John Doe")
      assert_equal 1, User.count
      assert_equal "John Doe", user.name
    end
  end
end