require 'test_helper'

class Facebook::BiographiesControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @pet = pets(:persian)
    @params = {:temperament => 'Aloof', :lifestyle => 'Indoor', :gender => 'Tom', :favorite_color => 'Blue',
               :favorite_food => 'Treats', :favorite_pastime => 'Playing', :favorite_season => 'Spring',
               :favorite_philosopher => 'Descartes', :favorite_composer => 'J.S. Bach',
               :pedigree => 'Purebred', :circadian => 'Nocturnal', :voice => 'Smooth', :zodiac => 'Mouser',
               :birthday => '2010-1-1', :siblings => 2, :description => 'Test pet. Test pet. Test pet. Test pet. Test pet. Test pet. Test pet.'}    
  end

  def test_should_show_new_bio
    mock_user_facebooking(@pet.user.facebook_id)
    facebook_get :new, :fb_sig_user => @pet.user.facebook_id

    assert_response :success
    assert_template 'new'
    assert_tag :tag => "form", :descendant => { 
      :tag => "table", :attributes => { :class => "breed-biography" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end

  def test_should_create_bio
    mock_user_facebooking(@pet.user.facebook_id)
    assert_difference 'Biography.count', +1 do
      facebook_post :create, :fb_sig_user => @pet.user.facebook_id, :biography => @params
    end
    assert_response :success, "response should be a success"
    assert_not_nil @pet.reload.biography, "biography should create for pet"
  end
end