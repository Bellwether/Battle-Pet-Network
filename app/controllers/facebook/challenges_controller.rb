class Facebook::ChallengesController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def index
    @challenges = current_user_pet.challenges.issued.defending
    @issued = current_user_pet.challenges.issued.attacking
    @resolved = current_user_pet.challenges.resolved.all
    @open = Challenge.open.issued
  end
  
  def new
    @pet = Pet.find(params[:pet_id])
    @challenge = Challenge.new(:attacker => current_user_pet, :defender => @pet)
    @gear = @pet.belongings.battle_ready
  end
  
  def open
    @pet = current_user_pet
    @challenge = Challenge.new(:attacker => current_user_pet)
    @gear = @pet.belongings.battle_ready
  end
  
  def create
    @pet = Pet.find_by_id(params[:pet_id])
    @challenge = Challenge.new(params[:challenge])
    @challenge.attacker = current_user_pet
    @challenge.attacker_strategy.combatant = @challenge.attacker unless @challenge.attacker_strategy.blank?
    @challenge.defender = @pet
    
    if @challenge.save
      flash[:notice] = "Challenge sent!"
      facebook_redirect_to facebook_pet_path(@pet)
    else
      flash[:error] = "Couldn't send challenge. :("
      flash[:error_message] = @challenge.errors.full_messages.join(', ')
      render :action => :new
    end
  end
  
  def refuse
    @challenge = Challenge.for_defender(current_user_pet).find(params[:id])
    if @challenge && @challenge.update_attribute(:status, 'refused')
      flash[:notice] = "Challenge refused"
    end
    redirect_facebook_back
  end
  
  def cancel
    @challenge = Challenge.for_attacker(current_user_pet).find(params[:id])
    if @challenge && @challenge.update_attribute(:status, 'canceled')
      flash[:notice] = "Challenge refused"
    end
    redirect_facebook_back
  end
  
  def edit
    @pet = current_user_pet
    @challenge = current_user_pet.challenges.responding_to(params[:id])
    @gear = @pet.belongings.battle_ready
  end
  
  def update
    @pet = current_user_pet
    @challenge = current_user_pet.challenges.responding_to(params[:id])
    @challenge.attributes = params[:challenge]
    @challenge.defender_strategy.combatant = @challenge.defender unless @challenge.defender_strategy.blank?
    
    if @challenge.save
      facebook_redirect_to facebook_challenges_path
    else
      flash[:error] = "Couldn't respond to challenge. :("
      flash[:error_message] = @challenge.errors.full_messages.join(', ')
      @gear = @pet.belongings.battle_ready
      render :action => :edit
    end
  end
  
  def show
    @pet = current_user_pet
    @challenge = current_user_pet.challenges.responding_to(params[:id])
    @opponent = @challenge.attacker_id == current_user_pet.id ? @challenge.attacker : @challenge.defender
    @history = Challenge.for_combatants(@pet.id, @opponent.id).resolved.excluding(@challenge.id).all(:limit => 12)
  end
end