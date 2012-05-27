require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get calibre_hosting" do
    get :calibre_hosting
    assert_response :success
  end

  test "should get download_ebook_ipad" do
    get :download_ebook_ipad
    assert_response :success
  end

  test "should get download_ebook_kindle" do
    get :download_ebook_kindle
    assert_response :success
  end

  test "should get calibre_ebook_conversion" do
    get :calibre_ebook_conversion
    assert_response :success
  end

  test "should get kindle_blog_subscribe" do
    get :kindle_blog_subscribe
    assert_response :success
  end

end
