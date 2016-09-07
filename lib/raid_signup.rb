class RaidSignup
  attr_reader :name

  def new(raid_name)
    @name = raid_name
    @roles = []
    @users = []
  end

  def load_roles(roles)
    @roles = roles.split
    @users = Array.new(@roles.size, 'Unassigned')
  end

  def is_assigned(user)
    @users.each do |value|
      return true if (value === user)
    end
    return false
  end

  def assign(user, role)
    if (self.already_assigned(user) === false)
      @roles.each_with_index do |role, index|
        if (@roles[index] === role && @users[index] === 'Unassigned')
          @users[index] = user
          return true
        end
      end
    else
      return false
    end
  end

  def unassign(user)
    @users.delete(user)
  end

  def roles_missing
    missing_roles = []
    @roles.each_with_index do |role, index|
      if (@users[index] === 'Unassigned')
        missing_roles.push(role)
      end
    end
    missing_roles.join(' ')
  end

  def users_signed
    users = []
    @users.each_with_index do |user, index|
      if (user != 'Unassigned')
        users.push("#{user} as #{@roles[index]}")
      end
    end

    users.join(' ')
  end
end
