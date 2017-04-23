module CustomRoles
  extend Discordrb::Commands::CommandContainer

  def self.can_manage?(user_roles)
    user_roles.any? { |role| role.permissions.manage_roles }
  end

  def self.new_role?(role, roles_list)
    !roles_list.any? { |r| r.name == role }
  end

  def self.find_role(role, roles_list)
    roles_list.find { |r| r.name == role }
  end

  def self.find_users_with(role, users)
    users.select { |u| u.role?(role) }
  end

  command(
    :createrole,
    chain_usable: false,
    description: "Adds a new role, usage: !createrole new_role. You need to be able to manage roles to use this."
  ) do |event, *args|
    message = ""
    custom_role = args.join(' ')
    #check if the user can manage roles
    return nil unless can_manage?(event.author.roles)
    #get this server
    server = event.server
    #create role if new role or send an error message otherwise
    if new_role?(custom_role, server.roles)
      role = server.create_role
      role.name = "#{custom_role}"
      role.mentionable = true
      message = "Role #{custom_role} was created."
    else
      message = "This role already exists."
    end

    event.respond message
  end

  command(
    :addrole,
    chain_usable: false,
    description: "Adds a role to the user invoking this command. Usage: !addrole role_you_want"
  ) do |event, *args|
    role = args.join(' ')
    #get the user
    user = event.author
    #get the server roles
    roles = event.server.roles
    #find the role wanted
    wanted_role = find_role(role, roles)
    #assign role to user or return an error message if not found
    if wanted_role.nil?
      "Can't find the role. This role might not exist."
    else
      user.add_role(wanted_role)
      "#{user.username} was added to #{role}."
    end
  end

  command(
    :removerole,
    chain_usable: false,
    description: "Remove a role from the user. Usage: !removerole role"
  ) do |event, *args|
    role = args.join(' ')
    #get user
    user = event.author
    #find the role
    roles = event.server.roles
    unwanted_role = find_role(role, roles)
    #remove role or send an error message if not found
    if unwanted_role.nil?
      "You don't have this role, bwaka!"
    else
      user.remove_role(unwanted_role)
      "#{user.username} was removed from #{role}."
    end
  end

  command(
    :listroles,
    chain_usable: false,
    description: "Lists all the roles in this server."
  ) do |event, role|
    message = ""
    #get server
    server = event.server
    #list all the roles if no role given
    if (role.nil? || role.empty?)
      message = "```Roles in this server\n"
      server.roles.each do |r|
        message << "#{r.name}\n"
      end
    else
      message = "```Users with this role:\n"
      role_object = find_role(role, server.roles)
      users = find_users_with(role_object, server.members)
      users.each do |user|
        message << "#{user.display_name}\n"
      end
    end

    message << "```"
    event.user.pm(message)
  end

end
