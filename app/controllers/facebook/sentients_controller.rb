class Facebook::SentientsController < Facebook::FacebookController
  def index
    @sentients = Sentient.threats.paginate(:page => params[:page], :order => :power)
  end
  
  def show
    @sentient = Sentient.threats.find(params[:id])
    @hunts = @sentient.hunts.all(:limit => 12)
  end
end