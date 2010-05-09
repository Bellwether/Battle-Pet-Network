class Facebook::ShopsController < Facebook::FacebookController
  def index
    @shop_filter_types = ['Food','Toy','Sensor','Mantle','Collar','Weapon','Standard','Charm','Ornament']
    @filters = params[:filters] ? params[:filters].split(',') : @shop_filter_types
    params[:filters] ||= @filters.join(',')
    
    filtering = @filters.size != @shop_filter_types.size
    scope = Shop.include_pet
    scope = scope.has_type_in_stock(params[:filters]) if filtering
    @shops = scope.paginate :page => params[:page]
  end
  
  def show
  end
end