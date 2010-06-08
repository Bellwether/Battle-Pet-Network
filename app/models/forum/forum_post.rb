class ForumPost < ActiveRecord::Base
  belongs_to :forum_topic, :counter_cache => true
  belongs_to :user

  validates_presence_of :body
  validates_presence_of :user_id, :topic_id
end