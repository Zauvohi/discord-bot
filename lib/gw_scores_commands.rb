module GWScoresCommands
  require_relative 'gw_scores'

  @gw_scores = GWScores.new
  @error_msg = "Missing info! Please provide the GW number and a URL with Drive folder holding the spreadsheets."

  command(
    :gw_edition,
    chain_usable: false,
    description: "Sets the current GW edition along with a google drive URL with the sheets. Example: gw_edition 29 URL_to_sheet"
  ) do |event, edition, url|
    event.respond @error_msg if (edition.empty? || url.empty?)
    @gw_scores.gw_number = edition
    @gw_scores.drive_url
  end

  command(
    :update_scores,
    chain_usable: false,
    description: "Updates/downloads the scores for a certain day. Example: !update_scores prelims. Accepted parameters 1 to 5, prelims and interlude."
  ) do |event, day|

  end
end
