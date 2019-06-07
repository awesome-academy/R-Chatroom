class Ability
  include CanCan::Ability

  def initialize user
    can :read, User

    if user.present?
      can :manage, User, id: user.id

      can :manage, Room do |room|
        can :kick, User do |another_user|
          room.has_joined? another_user
        end
        room.is_admin? user
      end

      can [:read, :create, :join, :leave], Room

      can :read, Room do |room|
        can :create, Message
      end

      can :read, Message do |message|
        message.room.has_joined? user
      end

      can :manage, Message, user_id: user.id
    end
  end
end
