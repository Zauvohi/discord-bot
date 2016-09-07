class RaidSignup

  def new(raid_name)
    @raid_name = raid_name
    @roles = []
    @users = []
  end

  def load_roles(roles)
    @roles = roles.split
    @users = Array.new(@roles.size, 'Unassigned')
  end

  def already_assigned(user)
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
        end
      end
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
end
