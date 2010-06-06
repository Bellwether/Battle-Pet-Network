class ForumPost < ActiveRecord::Base
  validates_presence_of :body
  validates_presence_of :user_id, :topic_id

  belongs_to :topic, :class_name => "ForumTopic", :counter_cache => true
  belongs_to :user  
end