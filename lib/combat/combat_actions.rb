module Combat::CombatActions
  require 'action_view/test_case'
  
  class Resolution
    attr_reader :first_damage
    attr_reader :second_damage
    attr_reader :description
            
    def initialize(first,first_action,second,second_action)
      @first = first
      @first_action = first_action
      @second = second
      @second_action = second_action
      
      resolve
    end
    
    def resolve
      if both_attacking?
        
      elsif both_defending?
      elsif first_attacking_second?
      elsif second_attacking_first?
      end
    end

    def did_undercut?(given_action,target_action)
      given_action.power == target_action.power - 1
    end
    
    def both_attacking?
      @first_action.offensive? && @second_action.offensive?
    end
    
    def both_defending?
      @first_action.defensive? && @second_action.defensive?
    end
    
    def first_attacking_second?
      @first_action.offensive? && @second_action.defensive?
    end
    
    def second_attacking_first?
      @first_action.defensive? && @second_action.offensive?
    end
  end
end