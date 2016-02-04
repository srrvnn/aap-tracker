require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get promote" do
    get :promote
    assert_response :success
  end

  test "should get demote" do
    get :demote
    assert_response :success
  end

end
