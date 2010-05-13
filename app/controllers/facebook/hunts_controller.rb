class Facebook::HuntsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def new
    @sentient = Sentient.find(params[:sentient_id])
    @hunt = @sentient.hunts.build(:hunters_attributes => {"0" => { :pet_id => current_user_pet.id }})
  end
  
  def create
    @sentient = Sentient.find(params[:sentient_id])
    @hunt = @sentient.hunts.build(params[:hunt])
    @hunt.hunters.first.pet = current_user_pet unless @hunt.hunters.blank?
    @hunt.hunters.first.strategy.combatant = current_user_pet unless @hunt.hunters.blank?
    
    if @hunt.save
      flash[:notice] = "The hunt for the #{@sentient.name} was #{@hunt.hunters.first.outcome}"
      facebook_redirect_to facebook_sentients_path
    else
      flash[:error] = "Couldn't start hunt. :("
      render :action => :new
    end
  end
end