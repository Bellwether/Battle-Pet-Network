class Facebook::HuntsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_pet
  
  def new
    @sentient = Sentient.find(params[:sentient_id])
    @hunt = @sentient.hunts.build(:hunters_attributes => [{ :pet_id => current_user_pet.id }])
  end
  
  def create
  end
end