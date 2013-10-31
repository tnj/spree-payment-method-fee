module Spree
  Order.class_eval do
    after_update :update_payment_method_fee

    def update_payment_method_fee
      return unless self.payment_method.present?

      fee = self.payment_method.fees.where(currency: self.currency).first

      destroy_fee_adjustments_for_order

      if fee.present?
        fee.add_adjustment_to_order(self)
      end

      adjustments.reload
    end

    def destroy_fee_adjustments_for_order
      fee_adjustments.destroy_all
    end

    def fee_adjustments
      self.adjustments.where( label: 'fee' )
    end
  end
end

