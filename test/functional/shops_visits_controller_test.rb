require 'test_helper'

class ShopsVisitsControllerTest < ActionController::TestCase
  setup do
    @shops_visit = shops_visits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shops_visits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shops_visit" do
    assert_difference('ShopsVisit.count') do
      post :create, :shops_visit => @shops_visit.attributes
    end

    assert_redirected_to shops_visit_path(assigns(:shops_visit))
  end

  test "should show shops_visit" do
    get :show, :id => @shops_visit.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @shops_visit.to_param
    assert_response :success
  end

  test "should update shops_visit" do
    put :update, :id => @shops_visit.to_param, :shops_visit => @shops_visit.attributes
    assert_redirected_to shops_visit_path(assigns(:shops_visit))
  end

  test "should destroy shops_visit" do
    assert_difference('ShopsVisit.count', -1) do
      delete :destroy, :id => @shops_visit.to_param
    end

    assert_redirected_to shops_visits_path
  end
end
