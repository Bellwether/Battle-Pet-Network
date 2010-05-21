require 'test_helper'

class Facebook::OccupationsControllerTest < ActionController::TestCase     
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = users(:two)
    @pet = @user.pet
  end

  def test_index
    mock_user_facebooking(@user.facebook_id)
    facebook_get :index, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'index'
    assert !assigns(:occupations).blank?
    Occupation.all.each do |o|
      assert_tag :tag => "div", :attributes => { :class => "occupation-#{o.slug}-mid" }      
      if o.pet_doing?(@controller.current_user_pet)
        assert_no_tag :tag => "span", :attributes => { :id => "#{@controller.current_user_pet.occupation.slug}-btn" }
      else  
        assert_tag :tag => "span", :attributes => { :id => "#{o.slug}-btn" }
      end
    end
  end
  
  def test_update
    occupation = occupations(:taming)
    mock_user_facebooking(@user.facebook_id)
    facebook_put :update, :fb_sig_user => @user.facebook_id, :id => occupation.id
    assert_response :success
    assert_equal occupation.id, @controller.current_user_pet.occupation_id
    assert flash[:notice]
  end
  
  def test_attempt
    occupation = occupations(:scavenging)
    mock_user_facebooking(@user.facebook_id)
    AppConfig.occupations.scavenge_chance_divisor = 1 / 1000
    assert_difference '@pet.belongings.count', +1 do    
      facebook_put :attempt, :fb_sig_user => @user.facebook_id, :id => occupation.id
      assert_response :success
      assert flash[:notice]
    end
  end
end