require 'test_helper'

class ForumPostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @topic = forum_topics(:discussion_rules)
  end
  
  def test_touch_parents
    post = @topic.posts.build(:body => 'test', :user => @user)
    assert post.save
    assert_equal post, @topic.reload.last_post
    assert_equal post, @topic.forum.last_post
  end
end