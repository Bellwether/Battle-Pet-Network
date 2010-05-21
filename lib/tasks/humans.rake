namespace :bpn do
  namespace :humans do
    
    desc "Generate income from enslaved humans"
    task(:labor => :environment) do
      pets = Pet.all(:joins=>"INNER JOIN tames ON pets.id = tames.pet_id", :conditions => {:status => 'enslaved'})
      pets.each do |pet|
        pet.update_attribute(:kibble, pet.kibble + pet.slave_earnings)
      end
    end
  end
end