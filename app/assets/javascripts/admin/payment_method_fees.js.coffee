$ ->
  $('#add-payment-method-fee').on 'click', ->
    id = new Date().getTime()
    html = $(this).data('form').replace(/XYZ/g, id )
    $('#payment-methods').append(html)

  $('.container').on 'click', '.remove-payment-method-fee', ->
    $(this).prev('input[type=hidden]').val(1)
    $(this).closest('.currency-fields').hide()

