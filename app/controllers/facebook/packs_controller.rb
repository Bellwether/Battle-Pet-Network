class Facebook::PacksController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def new
    @pack = Pack.new
  end
  
  def create
    @pack = Pack.new(params)

    if @pack.save
      flash[:notice] = "Today will be remembered in history as the founding of your pack!"
      facebook_redirect_to facebook_pack_path(@pack)
    else
      flash[:error] = "Couldn't found pack! :("
      render :action => :new
    end    
  end
end