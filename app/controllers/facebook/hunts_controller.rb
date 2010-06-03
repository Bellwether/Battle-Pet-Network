class Facebook::HuntsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def new
    @sentient = Sentient.find(params[:sentient_id])
    
    defaults = {:hunters_attributes => {"0" => { :pet_id => current_user_pet.id, :strategy_attributes => {} }}}
    @hunt = @sentient.hunts.build(defaults)
  end
  
  def create
    @sentient = Sentient.find(params[:sentient_id])
    @hunt = @sentient.hunts.build(params[:hunt])
    unless @hunt.hunters.blank?
      @hunt.hunter.pet = current_user_pet 
      @hunt.hunter.strategy.combatant = current_user_pet
    end

    if @hunt.save
      flash[:notice] = "The hunt for the #{@sentient.name} was #{@hunt.hunters.first.outcome}"
      facebook_redirect_to facebook_sentients_path
    else
      flash[:error] = "Couldn't start hunt. :("
      render :action => :new
    end
  end
  
  def show
    @hunt = current_user_pet.hunters.find_by_hunt_id(params[:id])
    @hunts = current_user_pet.hunters.all(:limit => 12).map(&:hunt)
  end
end