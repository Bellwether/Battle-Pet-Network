class Facebook::OccupationsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def index
    @occupations = Occupation.all(:order => 'name')
  end
  
  def update
    @occupation = Occupation.find(params[:id])
    current_user_pet.update_occupation!(@occupation.id)
    
    flash[:notice] = "You've started #{@occupation.name.downcase}"
    redirect_facebook_back
  end
  
  def attempt
    @occupation = Occupation.find(params[:id])
    current_user_pet.update_occupation!(@occupation.id)
    
    if @occupation.pet_can?(current_user_pet)
      @occupation.do_for_pet!(current_user_pet)
      flash[:notice] = "You tried #{@occupation.name.downcase}"
    else  
      flash[:notice] = "Could not do #{@occupation.name.downcase}"
    end
    
    redirect_facebook_back
  end
end