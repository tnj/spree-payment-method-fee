Deface::Override.new(
  virtual_path: "spree/admin/payment_methods/_form",
  name: "payment_method_fees",
  insert_after: '[data-hook=description]',
  partial: "spree/admin/payment_methods/fees",
  disabled: false
)

