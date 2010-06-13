class Facebook::ForumPostsController < Facebook::FacebookController
  def create
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:forum_topic_id])
    @post = @topic.posts.new(params[:forum_post])
    @post.user = current_user
    
    if @post.save
      flash[:success] = "Post created"
    else
      flash[:error] = "Couldn't create post! :("
      flash[:error_message] = @post.errors.full_messages.join(', ')
    end  
    facebook_redirect_to facebook_forum_forum_topic_path(@forum,@topic)
  end
end