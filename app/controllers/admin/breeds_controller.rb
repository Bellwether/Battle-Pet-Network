class Admin::BreedsController < Admin::AdminController
  def index
    @breeds = Breed.all
  end
  
  def edit
    @breed = Breed.find(params[:id])
  end
  
  def update
    @breed = Breed.find(params[:id])
  end
end