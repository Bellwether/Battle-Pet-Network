class ForumTopic < ActiveRecord::Base
  belongs_to :forum, :counter_cache => true
  belongs_to :user
  belongs_to :last_post, :class_name => "ForumPost"
  has_many :posts, :class_name => "ForumPost", 
                   :foreign_key => "forum_topic_id", 
                   :order => "created_at DESC"
  
  def touch_views!
    update_attribute(:views, views + 1)
  end
    
  def editable_by?(user)
    user && (user.id == user_id)
  end  
  
  def sticky?
    return self.sticky
  end  
  
  def locked?
    return self.locked
  end
end