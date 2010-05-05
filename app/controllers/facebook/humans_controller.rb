class Facebook::HumansController < Facebook::FacebookController
  def index
    @humans = Human.paginate :page => params[:page], :order => 'human_type, required_rank ASC'
  end
  
  def show
    @human = Human.find_by_id(params[:id]) || Human.new
  end
end