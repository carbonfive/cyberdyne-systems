class window.UserState extends Backbone.Model
  url: '/calls/next'

  initialize:(options)->
    @call = options?.call
    @userId = options?.userId

    @pusher = new Pusher(options?.pusherKey)
    @channel = @pusher.subscribe('userStates')
    @channel.bind('cyberdyne:userStateChanged', @updateState)

  updateState: (data)=>
    if data.user_id == @userId
      @set(state: data.state)
      if @call?
        switch data.state
          when 'waiting'
            @call.set(phone_number: 'Waiting for call...')
          when 'on_a_call'
            @call.set(phone_number: data.call.phone_number)
          else
            @call.unset('phone_number')
