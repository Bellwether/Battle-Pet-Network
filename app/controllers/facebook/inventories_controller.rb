class Facebook::InventoriesController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def create
    @shop = current_user_pet.shop
    @inventory = @shop.inventories.build(params[:inventory])
    
    if @inventory.save
      flash[:notice] = "Item added to your inventory"
    else
      flash[:alert] = "Couldn't add item to inventory! :("
    end
    redirect_facebook_back
  end
  
  def destroy
    @shop = current_user_pet.shop
    @inventory = @shop.inventories.find(params[:id])
    @inventory.unstock!
    flash[:notice] = "Item added to your inventory"
    redirect_facebook_back
  end
end
