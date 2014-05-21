require 'test_helper'

class VariantsControllerTest < ActionController::TestCase
  setup do
    @variant = variants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variant" do
    assert_difference('Variant.count') do
      post :create, variant: { description: @variant.description, kimnatVin: @variant.kimnatVin, kimnatYa: @variant.kimnatYa, mistoVin: @variant.mistoVin, mistoYa: @variant.mistoYa, typVin: @variant.typVin, typYa: @variant.typYa }
    end

    assert_redirected_to variant_path(assigns(:variant))
  end

  test "should show variant" do
    get :show, id: @variant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variant
    assert_response :success
  end

  test "should update variant" do
    patch :update, id: @variant, variant: { description: @variant.description, kimnatVin: @variant.kimnatVin, kimnatYa: @variant.kimnatYa, mistoVin: @variant.mistoVin, mistoYa: @variant.mistoYa, typVin: @variant.typVin, typYa: @variant.typYa }
    assert_redirected_to variant_path(assigns(:variant))
  end

  test "should destroy variant" do
    assert_difference('Variant.count', -1) do
      delete :destroy, id: @variant
    end

    assert_redirected_to variants_path
  end
end
