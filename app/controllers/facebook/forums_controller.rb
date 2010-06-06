class Facebook::ForumsController < Facebook::FacebookController
  def index
    @forums = Forum.include_last_post.ranked.all
  end
  
  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.paginate :page => params[:page]
  end
end