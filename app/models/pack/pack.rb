class Pack < ActiveRecord::Base
  before_validation_on_create :set_leader

  def set_leader
    self.leader_id = self.founder_id
  end
end