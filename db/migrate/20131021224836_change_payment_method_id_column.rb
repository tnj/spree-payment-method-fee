class ChangePaymentMethodIdColumn < ActiveRecord::Migration
  def change
    rename_column :spree_payment_method_fees, :spree_payment_method_id, :payment_method_id
  end
end
