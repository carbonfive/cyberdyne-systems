class window.CallView extends Backbone.View
  el: '#call'

  initialize: ->
    @model.on('change', @render, @)

  events:
    'click .make-call': 'makeCall'

  makeCall: (event)->
    event.preventDefault()
    phoneNumber = @$('input').val()
    @model.save(phone_number: phoneNumber)

  render: ->
    if @model.get('phone_number')?
      $('input').val(@model.get('phone_number'))
      @$('.make-call').attr('disabled', 'disabled').addClass('disabled')
      @$('input').attr('disabled', 'disabled').addClass('disabled')
    else
      $('input').val('')
      @$('.make-call').removeAttr('disabled').removeClass('disabled')
      @$('input').removeAttr('disabled').removeClass('disabled')
