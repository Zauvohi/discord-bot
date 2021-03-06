require 'csv'
require 'dotenv'
require 'google_drive'

class GWScores
  Dotenv.load('../.env')
  DIR_LOCATION = "#{__dir__}/spreadsheets/"
  GW_DAYS = ["prelims", "interlude", "1", "2", "3", "4", "5"]
  GW_CUTOFFS = ["20", "30", "40", "80"]

  attr_accessor :gw_number, :drive_url, :sheet_url

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

  def get_cutoffs(day)
    day = get_lastest_day if day.nil?
    data = get_parsed_data(day)
    cutoffs = []
    GW_CUTOFFS.each do |co|
      temp = data.find { |row| row[0] == co + "000" }
      # [position, points]
      cutoffs << [temp[0], temp[4]]
    end

    cutoffs
  end

  def print_cutoffs(day)
    day = get_lastest_day if day.nil?
    msg = "```Cutoffs for day: #{day} \n\n"
    cutoffs = get_cutoffs(day)

    cutoffs.each do |cutoff|
      msg += "# #{cutoff[0]} - #{cutoff[1]}\n"
    end
    msg += "```"
    msg
  end

  def fill_scores_sheet(score, enemy_score)
    session = GoogleDrive::Session.from_service_account_key(ENV['G_FILE'])
    sheet = session.spreadsheet_by_key(@spreadsheet_key).worksheets[0]
    row = get_empty_row(sheet)
    current_time = Time.now.getlocal('-07:00') #PDT change once Daylight savings is over
    sheet[row, 2] = current_time
    sheet[row, 4] = score
    sheet[row, 5] = enemy_score
    sheet.save
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

  def get_newest_formatting(day)
    base_name = "第#{@gw_number}回古戦場_個人貢献度ランキング_"

    if (day == "prelims")
      day_name = "予選"
    elsif (day == "interlude")
      day_name = "インターバル"
    elsif (day == "5")
      #day_name = "#{day}日目_速報"
      day_name = "本戦_#{day}日目_速報値"
    else
      day_name = "#{day}日目"
    end

    "#{base_name}#{day_name}"
  end

  def get_previous_formatting(day)
    if (day == "prelims")
      "第#{@gw_number}回古戦場_予選_個人貢献度ランキング"
    elsif (day == "interlude")
      "第#{@gw_number}回古戦場_インターバル_個人貢献度ランキング"
    else
      "第#{@gw_number}回古戦場_個人貢献度ランキング_本戦_#{day}日目"
    end
  end

  def get_old_formatting(day)
    if (day == "prelims")
      "第#{@gw_number}回古戦場_予選_個人貢献度ランキング"
    elsif (day == "interlude")
      "第#{@gw_number}回古戦場 インターバル 個人貢献度表"
    elsif (day == "5")
      "第#{@gw_number}回古戦場_本戦#{day}日目_個人貢献度ランキング_速報"
    else
      "第#{@gw_number}回古戦場_本戦#{day}日目_個人貢献度ランキング"
    end
  end

  def get_file_in_collection(collection, name)
    collection.file_by_title("#{name}.csv")
  end

  def download_ranking_data_for(day)
    session = GoogleDrive::Session.from_service_account_key(ENV['G_FILE'])
    collection = session.collection_by_url(@drive_url)
    formatting_methods = [
      method(:get_newest_formatting),
      method(:get_previous_formatting),
      method(:get_old_formatting)
    ]

    fname = ""
    file = nil
    file_name = "gw_#{@gw_number}"

    3.times do |i|
      fname = formatting_methods[i].call(day)
      file = get_file_in_collection(collection, fname)
      break unless file.nil?
    end


    return nil if file.nil?

    file.download_to_file("#{DIR_LOCATION}#{file_name}_individual_rankings_#{day}.csv")
  end

  def get_empty_row(sheet)
    # time is on B column (2)
    empty_in = 0
    for i in 5..96
      if sheet[i, 2] == ""
        empty_in = i
        break
      end
    end
    empty_in
  end
end
