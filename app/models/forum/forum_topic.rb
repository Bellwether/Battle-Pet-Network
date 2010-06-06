class ForumTopic < ActiveRecord::Base
  belongs_to :forum, :counter_cache => true
  belongs_to :user
  has_many :forum_posts, :order => "created_at DESC"
  
  def touch_views!
    update_attribute(:views, views + 1)
  end
    
  def editable_by?(user)
    user && (user.id == user_id)
  end  
end