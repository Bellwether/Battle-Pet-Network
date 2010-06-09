class ForumPost < ActiveRecord::Base
  belongs_to :forum_topic, :counter_cache => true
  belongs_to :user

  validates_presence_of :body
  validates_presence_of :user_id
  
  after_create :touch_parents
  
  def touch_parents
    forum_topic.update_attribute(:last_post_id, self.id)
    forum_topic.forum.update_attribute(:last_post_id, self.id)
  end
end