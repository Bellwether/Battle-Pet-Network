require 'test_helper'

class PaymentOrderTest < ActiveSupport::TestCase
  def setup
    @item = items(:kibble_pack)
    @user = users(:two)
  end
  
  def test_price_in_cents
    po = PaymentOrder.new(:item => @item)
    assert_not_equal @item.cost.to_s, po.price_in_cents.to_s
    assert po.price_in_cents.to_s.match /\d+\.\d+$/
  end 
  
  def test_set_total
    po = @user.payment_orders.new(:item => @item)
    po.save
    assert_equal po.price_in_cents, po.total
  end  
end