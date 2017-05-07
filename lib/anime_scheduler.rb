class AnimeScheduler

  require 'tzinfo'
  require 'date'
  require 'rufus-scheduler'

  TZ = "+09:00" # JST - Japan/Tokyo
  attr_reader :days, :schedules, :channel_ids, :bot, :role

  def initialize
    @days = {
      sunday: 0,
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6
    }
    @schedules = {
      saturday: [
        {
          time: '06:30',
          station:'AT-X (Repeat Broadcast)',
          location: 'Tokyo'
        },
        {
          time: '24:00',
          station:'TOKYO MX',
          new_ep: true,
          location: 'Tokyo'
        }
      ],
      sunday: [
        {
          time: '03:28',
          station:'MBS',
          location: 'Osaka'
        },
        {
          time: '06:30',
          station:'AT-X (Repeat Broadcast)',
          location: 'Tokyo'
        }
      ],
      monday: [
        {
          time: '22:30',
          station:'AT-X',
          location: 'Tokyo'
        }
      ],
      wednesday: [
        {
          time: '02:28',
          station: 'Hokkaido Broadcasting',
          location: 'Hokkaido'
        },
        {
          time: '14:30',
          station: 'AT-X (Repeat Broadcast)',
          location: 'Tokyo'
        }
      ],
      thursday: [
        {
          time: '02:05',
          station: 'TV Aichi',
          location: 'Aichi'
        },
        {
          time: '02:30',
          station: 'RKB Mainichi Broadcasting',
          location: 'Fukuoka'
        }
      ],
      friday: [
        {
          time: '01:55',
          station: 'Sagatevi',
          location: 'Saga'
        }
      ]
    }
    @scheduler = Rufus::Scheduler.new
    @channel_ids = []
    @bot = nil
    @role = nil
  end

  def add_role(role)
    @role = role
  end

  def add_channel(id)
    @channel_ids.push(id)
  end

  def remove_channel(id)
    index = @channel_ids.index(id)
    @channel_ids.slice!(index)
  end

  def add_bot(bot)
    @bot = bot
  end

  def airing_today
    today = Time.now.getlocal(TZ)
    msg = ""

    if (today.tuesday?)
      msg = "There's no airings today."
    else
      today_airings = airing_info(today.wday)
      airings = format_schedule(today_airings)
      msg = "Airings for #{@days.key(today.wday).to_s.capitalize}\n\n#{airings}"
    end
    msg
  end

  def next_airing
    today = Time.now.getlocal(TZ)
    next_airing_day = today.to_date.next_day
    # there's no airing on tuesday, so we make sure to skip it
    next_airing_day = next_airing_day.next_day if next_airing_day.tuesday?

    # check if we're still on time for today
    today_airings = airing_info(today.wday).find_all do |info|
      jst_date = convert_to_jst_date(today, info[:time])
      jst_date > today
    end

    if (today_airings.empty?)
      next_airings = airing_info(next_airing_day.wday)
      airings = format_schedule(next_airings)
      "Next airings for #{@days.key(next_airing_day.wday).to_s.capitalize}\n\n#{airings}"
    else
      airings = format_schedule(today_airings)
      "Remaining anime airings for today are: \n\n#{airings}"
    end
  end

  def timetable
    msg = "```This is the timetable for the GBF anime:\n\n"
    @schedules.each do |day, stations|
      msg += "#{day.to_s.capitalize}:\n"
      stations.each do |info|
        msg += "\t #{info[:time]} JST - #{info[:station]} (#{info[:location]}) \n"
      end
      msg += "\n"
    end
    msg += "```"
  end

  def already_scheduled?
    @scheduler.jobs(tag: "anime").size > 0
  end

  def schedule
    # set up all the schedulers for all tv stations
    # day: [{time, station, location, next_airing}]
    @schedules.each do |day, stations|
      stations.each do |info|
        seconds = get_next_airing_for(day.to_s, info[:time])
        message = "#{@role.mention} GBF Anime currently airing:\n#{info[:time]} JST - #{info[:station]} (#{info[:location]})"
        @scheduler.every "7d", first_in: "#{seconds}s", tag: "anime" do |job|
          @channel_ids.each do |channel|
            @bot.send_message(channel, message)
          end
        end
      end
    end

    puts @scheduler.jobs(tags: 'anime')
  end

  private

  def get_current_episode
    first_airing = Time.new(2017, 4, 1, 24, 0, 0, TZ)
    current_day = Time.now
    (((current_day - first_airing).to_i / (24 * 60 * 60)) / 7) + 1
  end

  def next_date_for(day)
    # we get the next how long until the next ep
    date = Date.parse(day)
    # if the lastest day we're looking for was last month, we have to increase
    # the days by 14 (2 weeks), otherwise it'll give us a negative number
    days_to_increase = Date.today.month > date.month ? 14 : 7
    # check if it's next week
    delta = date > Date.today ? 0 : days_to_increase
    (date + delta).to_time
  end

  def convert_to_jst_date(date, time)
    hours = time.split(':')[0]
    minutes = time.split(':')[1]
    Time.new(date.year, date.month, date.day, hours, minutes, 0, TZ)
  end

  def format_schedule(airings)
    msg = ""
    airings.each do |info|
      msg += "#{info[:time]} JST - #{info[:station]} (#{info[:location]}) \n"
    end
    msg
  end

  def get_next_airing_for(day, time)
    date = next_date_for(day)
    jst_date = convert_to_jst_date(date, time)
    (jst_date - Time.now.getlocal(TZ)).to_i
  end

  def airing_info(day)
    @schedules[@days.key(day)]
  end
end
