class Facebook::LobbyController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :only => [:invite]
  
  def index
  end
  
  def about
  end
  
  def guide
  end
  
  def tos
  end
  
  def contact
  end
  
  def invite
    @exclude_ids = current_user.facebook_friend_ids
  end
end