require 'csv'
require 'dotenv'
require 'google_drive'

class GWScores
  Dotenv.load('../.env')
  DIR_LOCATION = "#{__dir__}/spreadsheets/"
  GW_DAYS = ["prelims", "interlude", "1", "2", "3", "4", "5"]

  attr_accessor :gw_number, :drive_url

  def missing_info?
    @gw_number.nil? || @drive_url.nil?
  end

  def list_downloaded_files
    check_files.inspect
  end

  def download_files
    current_files = check_files
    missing_days = GW_DAYS - current_files
    missing_days.each do |day|
      download_ranking_data_for(day)
    end
    check_files
  end

  def find_player_by_id(id, day)
    day = get_lastest_day if day.nil?
    data = get_parsed_data(day)
    player_data = data.find { |row| row[1] == id }
    #player_data = [position, id, name, rank, points, battles, day]
    player_data.push(day)
  end

  def find_player_by_name(name, day)
    day = get_lastest_day if day.nil?
    data = get_parsed_data(day)
    #data = [position, id, name, rank, points, battles]
    player_data = data.find_all do |row|
      row[2] == name
    end

    player_data[0].push(day) if player_data.size == 1
    player_data
  end

  def print_players(players)
    return self.print_player_data(players.first) if players.size == 1

    msg = "```Multiple players found:\n\n"

    players.each do |player|
        msg += "# #{player[0]} Name: #{player[2]} - Rank: #{player[3]} - ID: #{player[1]}\n"
    end
    msg += "```"
    msg
  end

  def print_player_data(data)
    %Q(
```Day: #{data[6]}
# #{data[0]}
Name: #{data[2]} (ID: #{data[1]}) Rank: #{data[3]}
Total points: #{data[4]}
Total battles: #{data[5]}```
    )
  end

  private

  def check_files
    fname = "gw_#{@gw_number}_individual_rankings_"
    files = Dir["#{DIR_LOCATION + fname}*"]
    days = []

    return days if files.empty?
    sorted_files = files.sort_by { |f| File.ctime(f) }

    sorted_files.each do |file|
      days << file.scan(/(\d.csv|interlude.csv|prelims.csv)/).first.last.gsub(".csv", "")
    end

    days
  end

  def get_parsed_data(day)
    return [] unless check_files.include?(day)

    file = "gw_#{@gw_number}_individual_rankings_#{day}.csv"
    csv = CSV.parse(File.read(File.join(DIR_LOCATION, file)), { col_sep: "\t" })
    csv.shift
    csv
  end

  def get_lastest_day
    check_files.last
  end

  def download_ranking_data_for(day)
    session = GoogleDrive::Session.from_service_account_key(ENV['G_FILE'])
    collection = session.collection_by_url(@drive_url)
    base_name ="第#{@gw_number}回古戦場_個人貢献度ランキング_"
    file_name = "gw_#{@gw_number}"

    if (day == "prelims")
      day_name = "予選.csv"
    elsif (day == "interlude")
      day_name = "インターバル.csv"
    else
      day_name = "#{day}日目.csv"
    end

    file = collection.file_by_title("#{base_name}#{day_name}")

    return nil if file.nil?

    file.download_to_file("#{DIR_LOCATION}#{file_name}_individual_rankings_#{day}.csv")
  end

end
