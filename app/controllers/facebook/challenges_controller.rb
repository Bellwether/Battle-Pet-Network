class Facebook::ChallengesController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def index
    @challenges = current_user_pet.challenges.issued.defending
    @issued = current_user_pet.challenges.issued.attacking
    @resolved = current_user_pet.challenges.resolved.all
  end
  
  def new
    @pet = Pet.find(params[:pet_id])
    @challenge = Challenge.new(:attacker => current_user_pet, :defender => @pet)
    @challenge.challenge_type = "1v1"
    @gear = @pet.belongings.battle_ready
  end
  
  def create
    @pet = Pet.find(params[:pet_id])
    @challenge = Challenge.new(params[:challenge])
    @challenge.attacker = current_user_pet
    @challenge.attacker_strategy.combatant = @challenge.attacker unless @challenge.attacker_strategy.blank?
    @challenge.defender = @pet
    @challenge.challenge_type = "1v1"
    
    if @challenge.save
      flash[:notice] = "Challenge sent!"
      redirect_facebook_back
    else
      flash[:error] = "Couldn't send challenge. :("
      render :action => :new
    end
  end
  
  def edit
    @pet = current_user_pet
    @challenge = current_user_pet.challenges.responding_to(params[:id])
    puts @challenge.inspect
    @gear = @pet.belongings.battle_ready
  end
end