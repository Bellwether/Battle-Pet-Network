class Facebook::PaymentOrdersController < Facebook::FacebookController
  def create
    @payment_order = current_user.payment_orders.new(params[:payment_order])
    
    if @payment_order.save
      res = EXPRESS_GATEWAY.setup_purchase( @payment_order.price_in_cents,
        :ip                => request.remote_ip,
        :order_id          => @payment_order.id,
        :description       => "#{@payment_order.item.name}: $#{@payment_order.price_in_cents}",
        :no_shipping       => true,
        :return_url        => facebook_items_path,
        :cancel_return_url => premium_facebook_items_path
      )
      redirect_to EXPRESS_GATEWAY.redirect_url_for(res.token)    
    else
      flash[:error] = "Could not start purchase: #{@payment_order.errors.full_mesages}"
      facebook_redirect_back
    end
  end
end