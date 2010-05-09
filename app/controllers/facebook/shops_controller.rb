class Facebook::ShopsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet, :except => [:index,:show]

  def index
    @shop_filter_types = ['Food','Toy','Sensor','Mantle','Collar','Weapon','Standard','Charm','Ornament']
    @filters = params[:filters] ? params[:filters].split(',') : @shop_filter_types
    params[:filters] ||= @filters.join(',')
    
    filtering = @filters.size != @shop_filter_types.size
    scope = Shop.include_pet
    scope = scope.has_type_in_stock(params[:filters]) if filtering
    scope = scope.has_item_named(params[:search]) unless params[:search].blank?
    
    @shops = scope.paginate :page => params[:page]
  end
  
  def show
  end
  
  def new
    @shop = current_user_pet.build_shop(params[:shop])
  end
  
  def create
    @shop = current_user_pet.build_shop(params[:shop])

    if @shop.save
      flash[:notice] = "Today marks the grand opening of your pet shop!"
      facebook_redirect_to facebook_shop_path(@shop)
    else
      render :action => :new
    end
  end
end