module Spree
  Order.class_eval do
    after_update :update_payment_method_fee

    def update_payment_method_fee
      if self.payment_method.present? && (fee = self.payment_method.fees.where(currency: self.currency).first).present?
        fee.add_adjustment_to_order(self)
      else
        destroy_fee_adjustments_for_order
      end
    end

    def destroy_fee_adjustments_for_order
      self.adjustments.where( label: 'fee' ).destroy_all
    end
  end
end

