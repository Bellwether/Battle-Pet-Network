class Admin::LevelsController < Admin::AdminController
  def index
    @levels = Level.all(:order => 'breed_id, rank ASC')
  end
  
  def edit
    @level = Level.find(params[:id])
  end
  
  def update
    @level = Level.find(params[:id])
  end
end