class window.UserState extends Backbone.Model
  url: '/calls/available_users'

  initialize:(options)->
    @call = options?.call
    @pusher = new Pusher('03a09054c5605d90e91e')
    @channel = @pusher.subscribe('userStates')
    @channel.bind('cyberdyne:userStateChanged', @updateState)

  updateState: (data)=>
    @set(state: data.state)
    if @call?
      switch data.state
        when 'waiting'
          @call.set(phone_number: 'Waiting for call...')
        when 'on_a_call'
          @call.set(phone_number: data.call.phone_number)
        else
          @call.unset('phone_number')
