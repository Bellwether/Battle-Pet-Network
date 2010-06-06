require 'test_helper'

class Facebook::ForumsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @pet = pets(:siamese)
    @user = @pet.user
  end
  
  def test_index
    facebook_get :index, :fb_sig_user => nil
    assert_response :success
    assert_template 'index'
    assert !assigns(:forums).blank?
    assert_tag :tag => "table", :attributes => { :class => "forums"}, :descendant => { 
      :tag => "tr", :attributes => { :class => "forum" }
    }
  end  
end