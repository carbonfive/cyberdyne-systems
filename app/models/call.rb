class Call < ActiveRecord::Base
  attr_accessible :phone_number, :state, :user, :call_sid

  belongs_to :user

  after_create :initiate!, if: :uninitiated?

  state_machine initial: :uninitiated do
    before_transition any => :connect_to_user, :do => :find_user_to_call, :unless => :user?

    before_transition :queued => :connected do |call, transition|
      call.user = User.find_by_call_sid(transition.args.first[:user_call_sid])
    end

    before_transition :connect_to_user => :connected do |call, transition|
      call.user.picked_up_call!(call_sid: transition.args.first[:user_call_sid])
    end

    before_transition :connect_to_phone_number => :connected do |call, transition|
      call.call_sid = transition.args.first[:call_sid]
    end

    before_transition any - :goodbye => :goodbye do |call, transition|
      call.user.hung_up!
    end

    after_transition :queued => :connected do |call|
      call.user.picked_up_call!
    end

    after_transition any => :call_user, :do => :make_call_to_user

    event :initiate do
      transition :uninitiated => :call_user, :if => :user?
      transition :uninitiated => :connect_to_user, :if => :known_phone_number?, :unless => :user?
      transition :uninitiated => :queued, :unless => [:known_phone_number?, :user?]
    end

    event :dequeued do
      transition :queued => :connected
    end

    event :user_connected do
      transition :connect_to_user => :connected
      transition :call_user => :connect_to_phone_number
    end

    event :phone_number_connected do
      transition :connect_to_phone_number => :connected
    end

    event :call_disconnected do
      transition all - :goodbye => :goodbye
    end
  end

  protected

  def known_phone_number?
    @_known_phone_number ||= Target.where(phone_number: phone_number).any?
  end

  def make_call_to_user
    self.user.picked_up_call!(call_sid: TwilioService.make(self).sid)
  end

  def find_user_to_call
    self.user = User.first
  end

  def user?
    self.user.present?
  end
end
