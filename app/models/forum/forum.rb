class Forum < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :within => 3..128

  has_many :topics, :class_name => "ForumTopic", 
                    :foreign_key => "forum_id", 
                    :order => "updated_at DESC, created_at DESC", 
                    :dependent => :delete_all
  belongs_to :last_post, :class_name => "ForumPost"
  
  named_scope :ranked, :order => "rank ASC"  
  named_scope :include_last_post, :include => {:last_post => :forum_topic}
  named_scope :open, :conditions => "forum_type = 'user'"
  
  validates_presence_of :forum_type
  validates_inclusion_of :forum_type, :in => %w(user staff pack breed)

  def after_initialize(*args)
    self.forum_type ||= 'user'
  end
end