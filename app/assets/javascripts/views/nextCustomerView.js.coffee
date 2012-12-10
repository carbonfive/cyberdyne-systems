class window.NextCustomerView extends Backbone.View
  el: '#next-customer'

  initialize: ->
    @model.call?.on('change', @render, @)

  events:
    'click' : 'fetchNextCustomer'

  render: ->
    if @model.call?.get('phone_number')?
      @$el.attr('disabled', 'disabled').addClass('diabled')
    else
      @$el.removeAttr('disabled', 'disabled').removeClass('disabled')

  fetchNextCustomer: ->
    @model.fetch()
    @model.call?.set(phone_number: 'Waiting for call...')
