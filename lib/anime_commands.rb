module AnimeCommands
  extend Discordrb::Commands::CommandContainer
  require_relative 'anime_scheduler'
  @anime_scheduler = AnimeScheduler.new
end
