require "test_helper"

class NewArticleCreationTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
    sign_in_as(@admin_user)
  end

  test "get new article form and create article" do

    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Sports', description: "some description"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    # we are looking for a word "Sports" in the redirects html page body ( in this case it is show page for @category object) )
    assert_match "Sports", response.body
  end

  test "get new article form and reject article submission with invalid title" do

    get "/articles/new"
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'S', description: "some description"} }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'

  end


end
