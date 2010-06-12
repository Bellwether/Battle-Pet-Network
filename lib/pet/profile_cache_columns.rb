module Pet::ProfileCacheColumns
  require 'action_view/test_case'
  
  COLUMN_ATTRIBUTES = ['affection','intelligence','health','endurance','power','fortitude','affection','experience','shopkeeping']
   
  module ClassMethods
    def intialize_profile_cache_counter_columns
  #     # metaclass = (class << self; self; end)
  #     # COLUMN_ATTRIBUTES.each |col| do
  #     # metaclass.instance_eval %(
  #     #   class_eval %(
  #     #     def update_#{col}_bonus_count(val)
  #     #       update_attribute(:#{col}, [#{col}_bonus_count+val,0].max )
  #     #     end
  #     #   )
  #     # end
    end
  end  
  
 def self.included(base) 
    base.extend ClassMethods
    base.intialize_profile_cache_counter_columns
 end
end