class Facebook::BelongingsController < Facebook::FacebookController
  include ApplicationHelper
  
  def index
    @items = current_user_pet.belongings.paginate :page => params[:page]
    @gear = current_user_pet.belongings.battle_ready   
  end
end