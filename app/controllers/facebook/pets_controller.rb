class Facebook::PetsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :except => [:index]
  
  def index
  end
  
  def home
  end
  
  def show
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
