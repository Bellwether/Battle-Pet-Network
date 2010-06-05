class Facebook::PetsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :except => [:index, :show]
  before_filter :ensure_has_pet, :only => [:combat,:profile,:update]
  
  def index
    scope = Pet.include_user
    scope = scope.searching(params[:search]) if params[:search]
    @pets = scope.paginate :page => params[:page]
  end
  
  def combat
    @pet = current_user_pet
    @strategies = current_user_pet.strategies.active
    @gear = @pet.belongings.battle_ready
    @levels = @pet.breed.levels
    @challenges = current_user_pet.challenges.resolved.all
  end
  
  def profile
    @pet = current_user_pet
    @messages = current_user_pet.inbox(:limit => 5)
    @signs = @pet.signs
    @challenges = current_user_pet.challenges.issued.defending
  end
  
  def show
    @pet = Pet.find_by_id(params[:id]) || Pet.new
  end
  
  def new
    @pet = Pet.new
    @breeds = Breed.all
  end
  
  def create
    @pet = current_user.pets.new(params[:pet])
    
    if @pet.save
      flash[:notice] = "Pet befriended!"
      facebook_redirect_to home_facebook_pets_path
    else
      flash[:error] = "Couldn't befriend pet! :("
      @breeds = Breed.all
      @breed = Breed.find_by_id(@pet.breed_id)
      render :action => :new
    end
  end

  def update
    if params[:pet]
      action_id = params[:pet][:favorite_action_id]
      success = true
      
      if action_id
        if current_user_pet.update_favorite_action!(action_id)
          flash[:notice] = "You're favorite action is now to #{current_user_pet.favorite_action.name}"
        else
          flash[:error] = "Couldn't update favorite action: #{current_user_pet.errors.full_messages}"
        end
      end
    else
      flash[:alert] = "Nothing to update"
    end
    
    redirect_facebook_back
  end
end
