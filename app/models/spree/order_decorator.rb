
module Spree
  Order.class_eval do
    state_machine.after_transition from: :payment, do: :apply_payment_method_fees!

    def apply_payment_method_fees!
      Spree::PaymentMethodFee.adjust!(self)
    end
  end
end

