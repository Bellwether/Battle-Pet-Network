require 'test_helper'

class Facebook::PetsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    mock_user_facebooking
  end
  
  def test_should_get_new_pet
    facebook_get :new, :fb_sig_user => users(:one).facebook_id
    assert_response :success
    assert_template 'new'
    assert assigns(:pet)
    assert assigns(:breeds)
    assert_tag :tag => "form", :descendant => { 
      :tag => "input", :attributes => { :name => "pet[breed_id]", :type => "hidden" },
      :tag => "div", :attributes => { :class => "breed-picker" },
      :tag => "table", :attributes => { :class => "breed-details" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end
  
  def test_should_create_pet
    pet_params = {:name=>"Lilly", :breed_id=>breeds(:persian).id}
    assert_difference 'Pet.count', +1, "pet should create under expected normal conditions but had errors" do
      facebook_post :create, :pet => pet_params, :fb_sig_user => users(:one).facebook_id
      assert_response :success
    end
  end

  def test_should_fail_create_pet
    pet_mock = flexmock(Pet)
    pet_mock.new_instances.should_receive(:save).and_return(false)
    
    pet_params = {:name=>"Lilly", :breed_id=>breeds(:persian).id}
    assert_no_difference 'Pet.count' do
      facebook_post :create, :pet => pet_params, :fb_sig_user => users(:one).facebook_id
      assert_response :success
      assert assigns(:pet)
      assert assigns(:breeds)
      assert assigns(:breed)
      assert_template 'new'
    end
  end

  def test_should_get_index_without_pet
    facebook_get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:pets)
    assert assigns(:champions)
  end

  def test_should_get_index_with_pet
    facebook_get :index, :fb_sig_user => users(:one).facebook_id
    assert_response :success
    assert_template 'index'
    assert assigns(:pets)
    assert assigns(:champions)
    assert assigns(:friends)
    assert assigns(:rivals)
  end
end