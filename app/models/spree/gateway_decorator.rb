Spree::Gateway.class_eval do
  # Due some wierdness with STI, we need to declare this here.
  # Otherwise, we get "undefined method `association_class' for nil:NilClass"
  has_many :fees, class_name: 'Spree::PaymentMethodFee', foreign_key: 'payment_method_id'
  attr_accessible :fees_attributes
end
