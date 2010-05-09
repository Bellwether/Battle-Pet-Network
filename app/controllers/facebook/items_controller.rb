class Facebook::ItemsController < Facebook::FacebookController
  def index
  end
  
  def store
    @items = Item.marketable.type_is(params[:id]).paginate(:order => 'items.stock DESC', :page => params[:page])
  end
  
  def premium
  end
end