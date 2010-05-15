class Facebook::SignsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def create
    # @sign = current_user_pet.buil
    # 
    # if @biography.save
    #   flash[:notice] = "What a story! #{current_user_pet.name}'s biography has been written."
    #   facebook_redirect_to facebook_pets_path(current_user_pet)
    # else
    #   flash[:error] = "Couldn't save biography! :("
    #   render :action => :new
    # end
  end
end