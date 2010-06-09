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
    assert_difference '@topic.reload.views_count', +1 do    
      facebook_get :show, :forum_id => @forum.id, :id => @topic.id, :fb_sig_user => nil
    end
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
    mock_user_facebooking(@user.facebook_id)
    facebook_get :new, :forum_id => @forum.id, :id => @topic.id, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'new'
    assert !assigns(:forum).blank?
    assert !assigns(:topic).blank?
    assert !assigns(:post).blank?
    assert_tag :tag => "form", :attributes => {:action => "/#{@controller.facebook_app_path}/forums/#{@forum.id}/forum_topics", :method => "post"} 
    assert_tag :tag => "form", :descendant => { :tag => "input", :attributes => { :name => "forum_topic[title]", :type => "text" } }
    assert_tag :tag => "form", :descendant => { :tag => "textarea", :attributes => { :name => "forum_topic[posts_attributes][0][body]" } }
    assert_tag :tag => "form", :descendant => { :tag => "input", :attributes => { :type => "submit" } }
  end
  
  def test_create
    mock_user_facebooking(@user.facebook_id)
    forum_topic_params = {:title=>"text", :posts_attributes => { '0' => {:body=>'TEST\nTEST\nTEST'} }}
    assert_difference ['ForumTopic.count','ForumPost.count'], +1, "message should create normally" do
      facebook_post :create, :forum_id => @forum.id, :forum_topic => forum_topic_params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:forum).blank?
      assert !assigns(:topic).blank?
      assert flash[:notice]
    end
  end

  def test_fail_create
    mock_user_facebooking(@user.facebook_id)
    forum_topic_params = {:posts_attributes => { '0' => {:body=>''} }}
    assert_no_difference ['ForumTopic.count','ForumPost.count'], "message should create normally" do
      facebook_post :create, :forum_id => @forum.id, :forum_topic => forum_topic_params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:forum).blank?
      assert !assigns(:topic).blank?
      assert flash[:error]
    end
  end
end