class PaymentOrder < ActiveRecord::Base
  has_many :transactions, :class_name => "PaymentOrderTransaction"
  belongs_to :item
  belongs_to :user
  
  validates_presence_of :item_id, :user_id, :total
  validates_numericality_of :total, :greater_than_or_equal_to => 1.0
  
  before_validation_on_create :set_total
  
  def price_in_cents
    return item ? (item.cost * 100).round.to_f : 0.0
  end
  
  def set_total
    self.total = price_in_cents
  end
end