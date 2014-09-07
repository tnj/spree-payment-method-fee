$ ->
  $('#add-payment-method-fee').on 'click', (e)->
    id = new Date().getTime()
    html = $(@).data('fields').replace(/XYZ/g, id )
    $('#fee-fields').append(html)
    e.preventDefault()

  $('.container').on 'click', '.remove-payment-method-fee', (e)->
    $(@).next('[name*=_destroy]').val(true)
    $(@).closest('.currency-fields').hide()
    e.preventDefault()

