Deface::Override.new(
  virtual_path: "spree/checkout/_payment",
  name: "checkout_payment_method_fees",
  replace: '[data-hook=checkout_payment_step]',
  partial: "spree/checkout/payment_methods_with_fees",
  disabled: false
)

