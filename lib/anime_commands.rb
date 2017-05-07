module AnimeCommands
  extend Discordrb::Commands::CommandContainer
  require_relative 'anime_scheduler'
  @anime_scheduler = AnimeScheduler.new

  command(
  :anime_today,
  chain_usable: false,
  description: "Returns a list of the stations anime airing today"
  ) do |event|
    event.respond @anime_scheduler.airing_today
  end

  command(
  :anime_next,
  chain_usable: false,
  description: "Returns the next airing day"
  ) do |event|
    event.respond @anime_scheduler.next_airing
  end

  command(
  :anime_sub,
  chain_usable: false,
  description: "Subscribe the current channel to the anime scheduler."
  ) do |event|
    @anime_scheduler.add_bot(event.bot) if @anime_scheduler.bot.nil?

    if (@anime_scheduler.role.nil?)
      role = event.server.roles.find { |r| r.name == "anime" }
      @anime_scheduler.add_role(role)
    end

    if (@anime_scheduler.already_scheduled?)
      @anime_scheduler.add_channel(event.channel.id)
    else
      @anime_scheduler.schedule
    end
    event.respond "Channel subscribed to anime!"
  end

  command(
  :anime_unsub,
  chain_usable: false,
  description: "Unsubscribe the current channelfrom the anime scheduler."
  ) do |event|
    @anime_scheduler.remove_channel(event.channel.id)
    event.respond "Channel unsubscribed."
  end

  command(
  :anime_timetable,
  chain_usable: false,
  description: "Returns a list of the timetable"
  ) do |event|
    event.user.pm(@anime_scheduler.timetable)
  end
end
