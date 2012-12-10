class User < ActiveRecord::Base

  attr_accessible :name, :email, :password, :password_confirmation, :phone_number, :call_sid

  authenticates_with_sorcery!

  validates :email,
            presence: true,
            email: true

  validates :password,
            presence: true,
            length: { minimum: 6 },
            confirmation: true,
            if: :password

  has_many :calls

  state_machine initial: :available do
    before_transition any - :waiting => :waiting do |user|
      user.call_sid = TwilioService.make_queue_pickup_call_to(user.phone_number).sid
    end

    before_transition any - :available => :available do |user|
      user.call_sid = nil
    end

    before_transition any - :on_a_call => :on_a_call do |user, transition|
      unless user.call_sid.present?
        user.call_sid = transition.args.first[:call_sid]
      end
    end

    after_transition any => any do |user|
      data = { state: user.state, user_id: user.id }
      unless user.calls.empty? or user.calls.last.goodbye?
        data.merge!(call: user.calls.last.as_json)
      end
      begin
        Pusher.trigger(['userStates'], 'cyberdyne:userStateChanged', data)
      rescue Pusher::Error
      end
    end

    event :pickup_from_queue do
      transition all => :waiting
    end

    event :picked_up_call do
      transition all => :on_a_call
    end

    event :hung_up do
      transition all => :available
    end
  end
end
