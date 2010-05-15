require 'test_helper'

class Facebook::SignsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @sender = pets(:siamese)
    @recipient = pets(:burmese)
    @user = @sender.user
  end
  
  def test_create
    mock_user_facebooking(@user.facebook_id)
    assert_difference ['Sign.count','@sender.signings.count','@recipient.signs.count'], +1 do
      facebook_post :create, :pet_id => @recipient.id, :sign_type => 'purr', :fb_sig_user => @user.facebook_id
      assert_response :success
      assert flash[:notice]
    end
  end
  
  def test_fail_create
    mock_user_facebooking(@user.facebook_id)
    assert_no_difference ['Sign.count','@sender.signings.count','@recipient.signs.count'] do
      facebook_post :create, :pet_id => @recipient.id, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert flash[:error]
    end
  end
end