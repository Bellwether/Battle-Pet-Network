class Facebook::ForumPostsController < Facebook::FacebookController
  def create
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:forum_topic_id])
    @post = @topic.posts.build(params[:forum_post])
    @post.user = current_user
    
    if @post.save
      flash[:notice] = "Post created"
    else
      flash[:error] = "Couldn't create post! :("
    end  
    facebook_redirect_to facebook_forum_forum_topic_path(@forum,@topic)
  end
end