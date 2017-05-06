module AnimeCommands
  extend Discordrb::Commands::CommandContainer
  require_relative 'anime_scheduler'
  @anime_scheduler = AnimeScheduler.new

  command(
  :anime_today,
  chain_usable: false,
  description: "Returns a list of the stations anime airing today"
  ) do |event|
  end

  command(
  :anime_next,
  chain_usable: false,
  description: "Returns the next airing day"
  ) do |event|
  end

  command(
  :anime_sub,
  chain_usable: false,
  description: "Subscribe the current channel to the anime scheduler."
  ) do |event|
  end

  command(
  :anime_unsub,
  chain_usable: false,
  description: "Unsubscribe the current channelfrom the anime scheduler."
  ) do |event|
  end

  command(
  :anime_timetable,
  chain_usable: false,
  description: "Returns a list of the timetable"
  ) do |event|
  end
end
