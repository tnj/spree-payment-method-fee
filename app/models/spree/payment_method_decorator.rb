Spree::PaymentMethod.class_eval do
  has_many :spree_payment_method_fees, foreign_key: 'spree_payment_method_id', class_name: 'Spree::PaymentMethodFee'
  attr_accessible :spree_payment_method_fees_attributes

  accepts_nested_attributes_for :spree_payment_method_fees, allow_destroy: true

  # i'd like a better way to do this, for now this works.
  def fees
    Spree::PaymentMethodFee.where(spree_payment_method_id: self.id)
  end
end
