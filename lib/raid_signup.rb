class RaidSignup
  attr_reader :name
  attr_reader :creator

  def initialize(raid_name, user)
    @name = raid_name.split("_").each { |v| v.capitalize! }.join(" ")
    @suggested_roles = []
    @users = {}
    @creator = user
  end

  def load_roles(roles)
    @suggested_roles = roles.upcase.split
  end

  def suggested_roles
    @suggested_roles
  end

  def is_assigned(user)
    @users.each do |key, value|
      return true if (key === user)
    end
    return false

  end

  def add(user, role)
    if (self.is_assigned(user) === false)
      @users[user] = role
    else
      false
    end
  end

  def unassign(user)
    return false unless self.is_assigned(user)
    @users.delete(user)
  end

  def users_joined
    @users.size
  end

  def raid_size
    @suggested_roles.size
  end

  def is_full?
    self.users_joined === self.raid_size
  end

  def users_signed
    users = []
    @users.each do |user, role|
      users.push("#{role} - #{user}")
    end

    users
  end
end
