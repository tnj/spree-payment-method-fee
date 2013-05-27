class CreateSpreePaymentMethodFees < ActiveRecord::Migration
  def change
    create_table :spree_payment_method_fees do |t|
      t.integer :spree_payment_method_id
      t.decimal :amount
      t.string :currency

      t.timestamps
    end
  end
end
