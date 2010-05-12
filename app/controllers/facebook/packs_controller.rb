class Facebook::PacksController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet, :except => [:show]
  before_filter :ensure_pack_mamber, :only => [:edit]
  
  def show
    @pack = Pack.find(params[:id])
  end
  
  def new
    @pack = current_user_pet.build_pack
    @standards = current_user_pet.belongings.standards
  end
  
  def create
    @pack = current_user_pet.build_pack(params[:pack])

    if @pack.save
      flash[:notice] = "Today will be remembered in history as the founding of your pack!"
      facebook_redirect_to facebook_pack_path(@pack)
    else
      flash[:error] = "Couldn't found pack! :("
      @standards = current_user_pet.belongings.standards
      render :action => :new
    end    
  end
  
  def edit
  end
  
  def ensure_pack_mamber
    @pack = Pack.find[:id]
    facebook_redirect_to facebook_pack_path(@pack) unless @pack.position_for(current_user_pet.id)
  end
end