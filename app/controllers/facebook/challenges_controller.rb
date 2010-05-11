class Facebook::ChallengesController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def new
    @pet = Pet.find(params[:pet_id])
    @challenge = Challenge.new(:attacker => current_user_pet, :defender => @pet)
  end
end