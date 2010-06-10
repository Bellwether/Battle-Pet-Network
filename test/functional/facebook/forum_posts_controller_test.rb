require 'test_helper'

class Facebook::ForumPostsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @pet = pets(:siamese)
    @user = @pet.user
    @forum = forums(:discussion)
    @topic = forum_topics(:discussion_rules)
    @topic.update_attribute(:locked,false)
  end
  
  def test_create
    mock_user_facebooking(@user.facebook_id)
    assert_difference ['ForumPost.count'], +1 do
      facebook_post :create, :forum_id => @forum.id, :forum_topic_id => @topic.id, :forum_post => {:body => "test"}, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:forum).blank?
      assert !assigns(:topic).blank?
      assert !assigns(:post).blank?
      assert flash[:notice]
    end
  end

  def test_fail_create
    mock_user_facebooking(@user.facebook_id)
    assert_no_difference ['ForumPost.count'] do
      facebook_post :create, :forum_id => @forum.id, :forum_topic_id => @topic.id, :forum_post => {:body => ""}, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:forum).blank?
      assert !assigns(:topic).blank?
      assert !assigns(:post).blank?
      assert flash[:error]
    end
  end
end