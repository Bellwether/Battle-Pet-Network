class Facebook::MessagesController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def outbox
    @messages = current_user_pet.outbox.paginate :page => params[:page]
  end
  
  def inbox
    @messages = current_user_pet.inbox.paginate :page => params[:page]
  end  
  
  def show
    @message = Message.find_for_pet(params[:id],current_user_pet)
  end
  
  def new
    @message = current_user_pet.outbox.new(:reply_to_id => params[:reply_to_id])
  end
  
  def create
    @message = current_user_pet.outbox.new(params[:message])
    
    if @message.save
      flash[:notice] = "Message sent"
      facebook_redirect_to outbox_facebook_messages_path
    else
      flash[:error] = "Couldn't send message! :("
      render :action => :new
    end
  end
  
  def destroy
    @message = current_user_pet.inbox.find(params[:id])
    @message.set_deleted!
    flash[:notice] = "Message trashed"
    facebook_redirect_to inbox_facebook_messages_path
  end
end