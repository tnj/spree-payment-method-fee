module Spree
  module CheckoutHelper
    def fee_display_amount( payment_method_fees, order )
      currency = order.currency
      fee = payment_method_fees.where(currency: currency).first

      return "" unless fee

      Money.new( fee.amount, { currency: currency } ).to_s
    end
  end
end
