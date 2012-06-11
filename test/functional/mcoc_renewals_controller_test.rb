require 'test_helper'

class McocRenewalsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    McocRenewals.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    McocRenewals.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to mcoc_renewals_url
  end

  def test_edit
    get :edit, :id => McocRenewals.first
    assert_template 'edit'
  end

  def test_update_invalid
    McocRenewals.any_instance.stubs(:valid?).returns(false)
    put :update, :id => McocRenewals.first
    assert_template 'edit'
  end

  def test_update_valid
    McocRenewals.any_instance.stubs(:valid?).returns(true)
    put :update, :id => McocRenewals.first
    assert_redirected_to mcoc_renewals_url
  end
end
