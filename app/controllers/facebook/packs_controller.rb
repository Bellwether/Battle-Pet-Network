class Facebook::PacksController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet, :except => [:show]
  
  def show
    @pack = Pack.include_pack_members.find(params[:id])
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
    @pack = current_user_pet.pack
    @items = current_user_pet.belongings.sellable.collect(&:items)
  end
  
  def update
  end

  def invite
    @pack = current_user_pet.pack
    @pet = Pet.find_by_slug(params[:invittee]) || Pet.find_by_name(params[:invittee])
    
    message = @pack.invite_membership(current_user_pet,@pet)
    if message.new_record?
      flash[:error] = "Couldn't send invite - #{message.errors.full_messages}"
    else
      flash[:notice] = "Invited #{params[:invittee]} to join"
    end
    redirect_facebook_back    
  end
end