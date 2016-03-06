Spree::PaymentMethod.class_eval do
  has_many :fees, class_name: 'Spree::PaymentMethodFee', foreign_key: 'payment_method_id'

  accepts_nested_attributes_for :fees, allow_destroy: true
end
