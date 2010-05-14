require 'test_helper'

class Facebook::PetsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @pet = pets(:siamese)
    @user = @pet.user
  end
  
  def test_get_pet
    mock_user_facebooking
    facebook_get :show, :id => pets(:siamese).id, :fb_sig_user => nil
    assert_response :success
    assert_template 'show'
    assert assigns(:pet)
    assert_tag :tag => "div", :attributes => { :class => 'box gear' }
    assert_tag :tag => "div", :attributes => { :class => 'box pack' }
    assert_tag :tag => "div", :attributes => { :class => 'box humans' }
  end
  
  def test_get_pet_for_user
    mock_user_facebooking(@user.facebook_id)
    facebook_get :show, :id => pets(:persian).id, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'show'
    assert assigns(:pet)
    assert_tag :tag => "span", :attributes => { :class => "sign-button left" }
  end
    
  def test_get_new_pet
    mock_user_facebooking(users(:one).facebook_id)
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
  
  def test_create_pet
    mock_user_facebooking(users(:one).facebook_id)
    pet_params = {:name=>"Lilly", :breed_id=>breeds(:persian).id}
    assert_difference 'Pet.count', +1, "pet should create under expected normal conditions but had errors" do
      facebook_post :create, :pet => pet_params, :fb_sig_user => users(:one).facebook_id
      assert_response :success
      assert flash[:notice]
    end
  end

  def test_fail_create_pet
    mock_user_facebooking(users(:one).facebook_id)
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
      assert flash[:error]
    end
  end

  def test_index_without_pet
    mock_user_facebooking
    facebook_get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:pets)
  end

  def test_index_with_pet
    mock_user_facebooking(users(:one).facebook_id)
    facebook_get :index, :fb_sig_user => users(:one).facebook_id
    assert_response :success
    assert_template 'index'
    assert assigns(:pets)
  end
  
  def test_combat_profile
    mock_user_facebooking(@user.facebook_id)
    facebook_get :combat, :id => pets(:persian).id, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'combat'
    assert !assigns(:pet).blank?
    assert !assigns(:levels).blank?
    assert !assigns(:challenges).blank?
    assert assigns(:strategies)
    assert assigns(:gear)
  end
end