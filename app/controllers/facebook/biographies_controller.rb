class Facebook::BiographiesController < Facebook::FacebookController
  include ApplicationHelper
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def new
    @biography = current_user_pet.build_biography
  end
  
  def create
    @biography = current_user_pet.build_biography(params[:biography])
    
    if @biography.save
      flash[:notice] = "What a story! #{current_user_pet.name}'s biography has been written."
      facebook_redirect_to facebook_pets_path(current_user_pet)
    else
      flash[:error] = "Couldn't save biography! :("
      render :action => :new
    end
  end
end