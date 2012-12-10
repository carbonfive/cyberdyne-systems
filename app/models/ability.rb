class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, User
    can :manage, Target
    can :manage, Call
  end
end
