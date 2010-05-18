class Facebook::PaymentOrderTransactionsController < Facebook::FacebookController
  before_filter :ensure_application_is_installed_by_facebook_user
  
  def new
    @po = PaymentOrder.find_or_initialize_by_user_token(current_user,params[:token])
    @po.ip_address = request.remote_ip
    
    if @po.save_and_purchase
      flash[:notice] = "Thanks! You purchased a #{@po.item.name}."
    else
      flash[:notice] = "There was a problem with your order."
      flash[:error] = @po.errors.full_messages
      puts @po.errors.full_messages
    end
  end
end