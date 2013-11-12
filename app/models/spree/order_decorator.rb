module Spree
  Order.class_eval do

    set_callback :updating_from_params, :before, :update_payment_method_fee, prepend: true

    def update_payment_method_fee
      return unless @updating_params['order'].present?
      payment_attributes = @updating_params['order']['payments_attributes']
      return unless payment_attributes.present?

      destroy_fee_adjustments_for_order

      payment_attributes.each do |payment|
        payment_method = PaymentMethod.find(payment[:payment_method_id])
        payment_method.fees.where(currency: self.currency).first.try do |fee|
          fee.add_adjustment_to_order(self)
        end
      end

      self.update_totals

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

