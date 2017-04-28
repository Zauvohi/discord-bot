module GWScoresCommands
  extend Discordrb::Commands::CommandContainer
  require_relative 'gw_scores'

  @gw_scores = GWScores.new
  @gw_scores.number = "29"
  @gw_scores.drive_url = "https://drive.google.com/drive/folders/0B2NyM2kaI7pReUt4VnJWYUNjTnc"
  @error_msg = "Missing info! Please provide the GW number and a URL with Drive folder holding the spreadsheets."

  command(
    :gw_update_info,
    chain_usable: false,
    description: "Sets the current GW edition along with a google drive URL with the sheets. Example: gw_edition 29 URL_to_sheet"
  ) do |event, edition, url|
    event.respond @error_msg if (edition.nil? || url.nil?)
    @gw_scores.gw_number = edition
    @gw_scores.drive_url = url
    event.respond "Info updated!"
  end

  command(
    :gw_update_scores,
    chain_usable: false,
    description: "Updates/downloads the missing scores."
  ) do |event|
    event.respond @error_msg if @gw_scores.missing_info?

    downloaded_files = @gw_scores.download_files
    msg = ""

    if (downloaded_files.size == 0)
      msg = "No info available."
    else
      msg = "Days available: "
      downloaded_files.each do |day|
        msg += "#{day}, "
      end
    end
    event.respond msg
  end

  command(
    :gw_score,
    chain_usable: false,
    description: "Lookup a player's ranking by his ID, it's possible to specify a day. Example: !gw_score 5456 5 This will lookup the player 5456 on the 5th day."
  ) do |event, id, day|
    player_data = @gw_scores.find_player_by_id(id, day)
    msg = ""

    if (player_data.empty?)
      msg = "No info available."
    else
      msg = @gw_scores.print_player_data(player_data)
    end
    event.respond msg
  end

  command(
    :gw_available_days,
    chain_usable: false
  ) do |event|
    @gw_scores.list_downloaded_files
  end
end
