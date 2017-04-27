require 'csv'
require 'pry'
require 'dotenv'

class GWScores
  Dotenv.load('../.env')
  DIR_LOCATION = "#{__dir__}/spreadsheets/"

  attr_accessor :gw_number, :gw_drive_url

  def initialize(gw_number, drive_url)
    @gw_number = gw_number
    @drive_url = drive_url
  end

  def download_ranking_data_for(day)
    session = GoogleDrive::Session.from_service_account_key(ENV['G_FILE'])
    collection = session.collection_by_url(@drive_url)
    base_name ="第#{@gw_number}回古戦場_個人貢献度ランキング_"
    file_name = "gw_#{@gw_number}_"

    if (day == "prelims")
      day_name = "予選.csv"
    elsif (day == "interlude")
      day_name = "インターバル.csv"
    else
      day_name = "#{day}日目.csv"
      file_name += "day_#{day}"
    end

    file = collection.file_by_title("#{base_name}#{day_name}")
    file.download_to_file("#{DIR_LOCATION}#{file_name}_individual_rankings.csv")
  end

  def self.get_parsed_data(day)
    file = "gw_#{@gw_number}_"

    if (day == "prelims" || day == "interlude")
      file += "#{day}"
    else
      file += "day_#{day}"
    end

    file =+ "_individual_rankings.csv"

    CSV.parse(File.read(File.join(DIR_LOCATION, file)), { col_sep: "\t" })
    csv.shift
  end

  def self.get_lastest_day
    f_name = "gw_#{@gw_number}_"
    l_name = "_individual_rankings.csv"
    days = Dir["#{DIR_LOCATION + f_name}_day_*#{l_name}"]
    prelims = Dir["#{DIR_LOCATION + f_name}_prelims#{l_name}"]

    if (days.size > 0)
      days.last.scan(/_\d_/).gsub('_', '')
    elsif (prelims.size > 0)
      "prelims"
    else
      "interlude"
    end
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
end
