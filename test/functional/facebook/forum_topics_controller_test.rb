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
  
  def test_new
    mock_user_facebooking(users(:two).facebook_id)
    facebook_get :new, :forum_id => @forum.id, :id => @topic.id, :fb_sig_user => users(:two).facebook_id
    assert_response :success
    assert_template 'new'
    assert !assigns(:forum).blank?
    assert !assigns(:topic).blank?
    assert !assigns(:post).blank?
    assert_tag :tag => "form", 
      :attributes => {:action => "/#{@controller.facebook_app_path}/forums/#{@forum.id}/forum_topics", :method => "post"}, 
      :descendant => { 
        :tag => "input", :attributes => { :name => "forum_topic[title]", :type => "text" },
        :tag => "textarea", :attributes => { :name => "forum_topic[post_attributes][body]" },
        :tag => "input", :attributes => { :type => "submit" }
    }
  end
  
end