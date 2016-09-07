class RaidSignup

  def new(raid_name)
    @raid_name = raid_name
    @roles = {}
  end

  def load_roles(roles)
    roles.each do |role|
      @roles[role] = 'Unassigned'
    end
  end

  def already_assigned(user)
    @roles.each do |key, value|
      return true if (value === user)
    end
    return false
  end

  def assign(user, role)
    if (self.already_assigned(user) === false)
      @roles[role] = user
    end
  end

  def unassign(user)
    @roles.each do |key, value|
      if (value === user)
        @roles[key] = 'Unassigned'
      end
    end
  end

  def roles_missing
    missing_roles = []
    @roles.each do |key, value|
      if (value === 'Unassigned')
        missing_roles.push(key)
    end
    missing_roles.join(' ')
  end
end
