require 'csv'
require 'dotenv'
require 'google_drive'

class GWScores
  Dotenv.load('../.env')
  DIR_LOCATION = "#{__dir__}/spreadsheets/"
  GW_DAYS = ["prelims", "interlude", "1", "2", "3", "4", "5"]

  attr_accessor :gw_number, :drive_url, :recorded_days

  def initialize
    @recorded_days = []
  end


  def check_files
    fname = "gw_#{@gw_number}_individual_rankings_"
    files = Dir["#{DIR_LOCATION + fname}*"]
    files.each do |file|
      @recorded_days << file.gsub(/\w+\d+\w+_/, "").gsub(".csv", "")
    end

    @recorded_days
  end

  def find_player_by_id(id, day)
    day = get_lastest_day if day.empty?
    data = get_parsed_data(day)
    #data = [position, id, name, rank, points, battles]
    data.find { |row| row[1] == id }
  end

  def print_player_data(data)
    %Q(
    ##{data[0]}
    Name: #{data[2]} (ID: #{row[1]}) Rank: #{data[3]}
    Total points: #{data[4]}
    Total battles: #{data[5]}
    )
  end

  private

  def self.get_parsed_data(day)
    return nil unless @recorded_days.include?(day)

    file = "gw_#{@gw_number}_individual_rankings_#{day}.csv"
    CSV.parse(File.read(File.join(DIR_LOCATION, file)), { col_sep: "\t" })
    csv.shift
  end

  def self.get_lastest_day
    @recorded_days.last
  end

  def self.download_ranking_data_for(day)
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
