class Facebook::LobbyController < Facebook::FacebookController
  before_filter :ensure_authenticated_to_facebook, :only => [:invite]
  
  def index
  end
  
  def about
  end
  
  def guide
  end
  
  def invite
  end
end