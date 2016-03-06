class Spree::PaymentMethodFee < ActiveRecord::Base
  belongs_to :payment_method, class_name: 'Spree::PaymentMethod'

  validates :currency, uniqueness: {scope: :payment_method_id}
  # validate :payment_method_confirmable

  # If a payment method isn't comfirmable then this extension would sneakily
  # add a fee to an order without showing the user the final total. make sure
  # the payment method shows a confirmation page if you want fees enabled.
  def payment_method_confirmable
    unless payment_method.payment_profiles_supported?
      self.errors.add(:base, "fees are only supported on payment methods which support payment profiles")
    end
  end

  def add_adjustment_to_order(order)
    order.destroy_fee_adjustments_for_order

    order.adjustments.create! source: order,
                              order: order,
                              amount: self.amount,
                              label: 'fee',
                              mandatory: true,
                              eligible: true
  end
end
