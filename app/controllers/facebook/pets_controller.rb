class Facebook::PetsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :except => [:index, :show]
  
  def index
    @pets = []
  end
  
  def combat
    @pet = current_user_pet
    @strategies = current_user_pet.strategies.active
    @gear = @pet.belongings.battle_ready
    @levels = @pet.breed.levels
    @challenges = current_user_pet.challenges.resolved.all
  end
  
  def home
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
end
