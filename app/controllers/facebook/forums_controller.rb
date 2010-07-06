class Facebook::ForumsController < Facebook::FacebookController
  def index
    @forums = if current_user && current_user.staff?
      Forum.include_last_post.ranked.all
    else
      Forum.include_last_post.open.ranked.all
    end
  end
  
  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.paginate :page => params[:page]
  end
end