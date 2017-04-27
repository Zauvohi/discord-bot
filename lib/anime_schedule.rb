class AnimeSchedule

  require 'tzinfo'
  require 'date'
  require 'rufus-scheduler'

  TZ = "+09:00" # JST - Japan/Tokyo

  @days = {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }
  #const with tv-station as key holding an array with the airing info
  #the array is [day, hour, tv-station, location, next airing]
  @schedules = {
    saturday: [
      {
        time: '24:00',
        station:'TOKYO MX',
        location: 'Tokyo',
        next_airing: ''
      },
      {
        time: '06:30',
        station:'AT-X (Repeat Broadcast)',
        location: 'Tokyo',
        next_airing: ''
      }
    ],
    sunday: [
      {
        time: '03:28',
        station:'MBS',
        location: 'Osaka',
        next_airing: ''
      },
      {
        time: '06:30',
        station:'AT-X (Repeat Broadcast)',
        location: 'Tokyo',
        next_airing: ''
      }
    ],
    monday: [
      {
        time: '22:30',
        station:'AT-X',
        location: 'Tokyo',
        next_airing: ''
      }
    ],
    wednesday: [
      {
        time: '02:28',
        station: 'Hokkaido Broadcasting',
        location: 'Hokkaido',
        next_airing: ''
      },
      {
        time: '14:30',
        station: 'AT-X (Repeat Broadcast)',
        location: 'Tokyo',
        next_airing: ''
      }
    ],
    thursday: [
      {
        time: '02:05',
        station: 'TV Aichi',
        location: 'Aichi',
        next_airing: ''
      },
      {
        time: '02:30',
        station: 'RKB Mainichi Broadcasting',
        location: 'Fukuoka',
        next_airing: ''
      }
    ],
    friday: [
      {
        time: '01:55',
        station: 'Sagatevi',
        location: 'Saga',
        next_airing: ''
      }
    ]
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

  def self.convert_to_jst_date(date, time)
    hours = time.split(':')[0]
    minutes = time.split(':')[1]
    Time.new(date.year, date.month, date.day, hours, minutes, 0, TZ)
  end

  def self.get_next_airing_for(day, time)
    date = next_date_for(day)
    jst_date = convert_to_jst_date(date, time)
    (jst_date - Time.now).to_i
  end

  def self.airing_info(day)
    @schedules[@days.key(day)]
  end

  def self.airing_for_today
    today = TZInfo::TimeZone.get('Asia/Tokyo')
    today_airing = airing_info(today.wday)

    today_airing.each do |info|
    end
  end

  def next_airing
    today = Date.today.wday
    next_airing_day = Date.today.next_day.wday
    # there's no airing on tuesday, so we make sure to skip it
    next_airing_day += 1 if next_day == 2

    # check if we're still on time for today
    next_ep = airing_info(today).find do |info|

    end

    # [:day, [airings info]]
    next_ep = @schedules.find do |day, info|
      @days[day] == next_airing_day
    end

    return next_ep if next_ep[1].size > 1

  end

  def setup
    # set up all the schedulers for all tv stations
    scheduler = Rufus::Scheduler.new

    @schedules.each do |station, info|
      day = @days.key(info[0]).to_s
      time = info[1]
      time = get_next_airing_for(day, time)
      msg = "GBF Anime currently airing at #{info[3]}, location: #{info[4]}"

      scheduler.every "7d", first_in: "#{time}s" do |job|
        @bot.send_message(@channel_id, msg)
      end
    end
  end
end
