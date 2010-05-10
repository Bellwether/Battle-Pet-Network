class Facebook::TamesController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet

  def index
    @tames = current_user_pet.tames.kenneled.all
    @slave_count = current_user_pet.tames.enslaved.count
  end
end