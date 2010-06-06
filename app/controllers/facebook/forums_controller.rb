class Facebook::ForumsController < Facebook::FacebookController
  def index
    @forums = Forum.include_last_post.ranked.all
  end
end