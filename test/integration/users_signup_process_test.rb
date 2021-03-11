require "test_helper"

class UsersSignupProcessTest < ActionDispatch::IntegrationTest


  test "get user sigh-up form and sign in user" do

    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "janedoe", email: "janedoe@example.com",
                                         password: "password", admin: false} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "janedoe", response.body
  end

  test "get user sigh-up form and reject invalid user submission" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "j", email: "janedoe@example.com",
                                         password: "password", admin: false} }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

end
