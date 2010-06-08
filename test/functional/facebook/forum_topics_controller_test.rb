require 'test_helper'

class Facebook::ForumTopicsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @pet = pets(:siamese)
    @user = @pet.user
    @forum = forums(:discussion)
    @topic = forum_topics(:discussion_rules)
  end
  
  def test_show
    facebook_get :show, :forum_id => @forum.id, :id => @topic.id, :fb_sig_user => nil
    assert_response :success
    assert_template 'show'
    assert !assigns(:forum).blank?
    assert !assigns(:topic).blank?
    assert !assigns(:posts).blank?
    assert_tag :tag => "table", :attributes => { :class => "topic"}, :descendant => { 
      :tag => "tr", :attributes => { :class => "post" }
    }
  end  
end