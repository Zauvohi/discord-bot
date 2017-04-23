class AnimeSchedule

  require 'tzinfo'
  require 'rufus-scheduler'

  #const with tv-station as key holding an array with the airing info
  #the array is [day, hour, tv-station, location]
  SCHEDULES = {
    TOKYO_MX: ['Saturday', '24:00', 'TOKYO MX', 'Tokyo'],
    MBS: ['Sunday', '03:28', 'MBS', 'Osaka'],
    ATX_MON: ['Monday', '22:30', 'AT-X', 'Tokyo'],
    ATX_WED: ['Wednesday', '14:30', 'AT-X (Repeat Broadcast)', 'Tokyo'],
    ATX_SAT: ['Saturday', '06:30', 'AT-X (Repeat Broadcast)', 'Tokyo'],
    ATX_SUN: ['Sunday', '06:30', 'AT-X (Repeat Broadcast)', 'Tokyo'],
    TV_AICHI: ['Thursday', '02:05', 'TV Aichi', 'Aichi'],
    HOKKAIDO: ['Wednesday', '02:28', 'Hokkaido Broadcasting', 'Hokkaido'],
    RKB: ['Thursday', '02:30', 'RKB Mainichi Broadcasting', 'Fukuoka'],
    SAGATEVI: ['Friday', '01:55', 'Sagatevi', 'Saga']
  }

  def initialize(bot, channel_id)
    @bot = bot
    @channel_id = channel_id
  end

  def self.next_date_for(day)
    # we get the next how long until the next ep
    date = Date.parse(day)
    # check if it's next week
    delta = date > Date.today ? 0 : 7
    date + delta
  end

  def self.get_next_airing_for(day, time)
    date = next_date_for(day)
    hour = time.split[0].to_i
    minutes = time.split[1].to_i
    jst = Time.new(date.year, date.month, date.day, hour, minutes, 0, "+09:00")
    (jst - Time.now).to_i
  end

  def next_airing

  end

  def setup
    # set up all the schedulers for all tv stations
    scheduler = Rufus::Scheduler.new

    SCHEDULES.each do |station, info|
      time = get_next_airing_for(info[0], info[1])
      msg = "GBF Anime currently airing at #{info[3]}, location: #{info[4]}"

      scheduler.every "7d", first_in: "#{time}s" do |job|
        @bot.send_message(@channel_id, msg)
      end
    end
  end
end
