Spree::Admin::PaymentMethodsController.class_eval do
  def before_update
    params[:payment_method][:fees_attributes] =
        params[ActiveModel::Naming.param_key(@payment_method)].delete(:fees_attributes)
  end
end
