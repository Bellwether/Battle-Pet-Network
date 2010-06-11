class ActivityStream < ActiveRecord::Base
  belongs_to :actor, :polymorphic => true
  belongs_to :object, :polymorphic => true
  belongs_to :indirect_object, :polymorphic => true

  validates_presence_of :category, :namespace
  validates_inclusion_of :category, :in => %w(analytics combat)
  
  after_validation_on_create :set_polymorph_data
  after_validation_on_create :set_description_data
  after_create :send_notifications
  
  class << self
    def log!(category,namespace,actor=nil,object=nil,indirect_object=nil,data={})
      return create(:category => category, 
                    :namespace => namespace, 
                    :actor => actor,
                    :object => object,
                    :indirect_object => indirect_object,
                    :activity_data => data)
    end
  end
  
  def after_initialize(*args)
    self.activity_data ||= {}
  end
  
  def set_description_data
    actor_name = activity_data[:actor_name]
    object_name = activity_data[:object_name]
    self.activity_data[:description] = 
      case category
        when 'combat'
          case namespace
            when 'challenge-1v1'
              "#{actor_name} challenged #{object_name} to batttle."
            when 'challenge-1v0'
              "#{actor_name} made an open challenge to battle."
            when 'refused'
              "#{actor_name} refused to battle #{object_name}."
            when 'battled'
              indirect_object.outcome
          end
        when 'hunting'
          case namespace
            when 'hunted'
              "#{actor_name} hunted a #{object_name} and #{indirect_object.hunter.outcome}."
          end
        when 'shopping'
          case namespace
            when 'purchase'  
              "#{actor_name} got a #{object_name} from #{indirect_object.name}'s shop."
            when 'stocking'
              "#{actor_name} added a #{object_name} to their shop."
            when 'unstocking'
              "#{actor_name} removed a #{object_name} from their shop."
          end
        when 'analytics'
          case namespace
            when 'registration'
              "#{actor_name} entered the world."
            when 'referer'
              "#{object_name} entered the world on your recommendation."
            when 'daily-login'
              "#{actor_name} found #{AppConfig.awards.daily_login} kibble after signing in."
            when 'invitation'
              "#{actor_name} invited friends to join."
          end
      end
  end
  
  def set_polymorph_data
    ['actor','object','indirect_object'].each do |model|
      m = self.send(model.to_sym)
      next if m.blank?
      
      self.activity_data["#{model}_name".to_sym] = 
        case m.class.name
          when 'User'
            send(model.to_sym).normalized_name
          when 'Pet'
            send(model.to_sym).name
        end
    end
  end
  
  def send_notifications
  end
end