class Facebook::PetsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :except => [:index]
  
  def index
  end
  
  def show
  end
  
  def new
  end
  
  def create
  end
end
