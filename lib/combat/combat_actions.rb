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
      
      @first_damage = 0
      @second_damage = 0
      
      resolve_damage
    end
    
    def resolve_damage
      if both_attacking?
        @first_damage = @first_action.power
        @second_damage = @second_action.power
      elsif first_attacking_second?
        if did_undercut?(@first_action, @second_action)
          @first_damage = @first_action.power * 2
        elsif second_action_greater?
          @first_damage = @first_action.power
        elsif first_action_greater?
          if did_undercut?(@second_action, @first_action)  
            @second_damage = @first_action.power * 2
          else
            @first_damage = @first_action.power - @second_action.power
          end
        end  
      elsif second_attacking_first?
        if did_undercut?(@second_action, @first_action)
          @second_damage = @second_action.power * 2
        elsif first_action_greater?
          @second_damage = @second_action.power
        elsif second_action_greater?
          if did_undercut?(@first_action, @second_action)
            @first_damage = @second_action.power * 2
          else
            @second_damage = @second_action.power - @first_action.power
          end
        end
      end
    end

    def did_undercut?(given_action,target_action)
      given_action.power == target_action.power - 1
    end
    
    def first_action_greater?
      @first_action.power > @second_action.power
    end

    def second_action_greater?
      @second_action.power > @first_action.power
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