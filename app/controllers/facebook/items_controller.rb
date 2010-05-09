class Facebook::ItemsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet, :only => [:purchase]
  
  def index
  end
  
  def store
    @items = Item.marketable.type_is(params[:id]).paginate(:order => 'items.stock DESC', :page => params[:page])
  end
  
  def purchase
    @item = Item.find(params[:id])
    @purchase = @item.purchase_for!(current_user_pet)
    @purchase_errors = @purchase.errors.on_base
        
    if @purchase_errors.blank?
      flash[:notice] = "You bought the #{@item.name}!"
    else    
      flash[:notice] = "Couldn't purchase item: #{@purchase_errors}"
    end
    redirect_facebook_back
  end
  
  def premium
  end
end