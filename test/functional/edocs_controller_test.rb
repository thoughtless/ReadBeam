require 'test_helper'

class EdocsControllerTest < ActionController::TestCase
  setup do
    @edoc = edocs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edocs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create edoc" do
    assert_difference('Edoc.count') do
      post :create, edoc: @edoc.attributes
    end

    assert_redirected_to edoc_path(assigns(:edoc))
  end

  test "should show edoc" do
    get :show, id: @edoc.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @edoc.to_param
    assert_response :success
  end

  test "should update edoc" do
    put :update, id: @edoc.to_param, edoc: @edoc.attributes
    assert_redirected_to edoc_path(assigns(:edoc))
  end

  test "should destroy edoc" do
    assert_difference('Edoc.count', -1) do
      delete :destroy, id: @edoc.to_param
    end

    assert_redirected_to edocs_path
  end
end
