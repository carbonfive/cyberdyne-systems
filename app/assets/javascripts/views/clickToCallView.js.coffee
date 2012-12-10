class window.ClickToCallView extends Backbone.View
  events:
    'click' : 'makeCall'

  initialize: ->
    @model.on('change', @onPhoneNumberChange, @)

  makeCall: (event)=>
    event.preventDefault()
    phoneNumber = @$el.attr('href').substr(4)
    @model.save(phone_number: phoneNumber)

  onPhoneNumberChange: ->
    @disabled = @model.get('phone_number')?
    @render()

  render: ->
    if @disabled
      @$el.addClass('disabled')
    else
      @$el.removeClass('disabled')
