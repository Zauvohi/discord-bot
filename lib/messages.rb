module Messages
  extend Discordrb::EventContainer
  require_relative 'utilities'

  def self.answers
    @answers ||= []
  end

  def self.load_answers
    File.open("#{__dir__}/answers.txt", "r") do |file|
      file.each_line do |line|
        @answers << line
      end
    end
  end

  message(content: /dumb clar+i*(c+|s+)e+/) do |event|
    clarise_pics = [
      "http://i.imgur.com/SVR6WMO.jpg",
      "http://i.imgur.com/RzOg0tr.png",
      "http://i.imgur.com/PW1LmeR.jpg",
      "http://i.imgur.com/xPscDma.png",
      "http://i.imgur.com/paiYnhF.jpg"
    ]
    event.respond Utilities.random_element(clarise_pics)
  end

  message(content: 'twitter.com') do |event|
    msg = event.message.to_s
    replacement = msg.gsub(/https:\/\/twitter.com/, "https://vxtwitter.com")
    event.respond(replacement)
  end

  mention(containing: /\sor\s+|\?/) do |event|
    bot_id = event.bot.profile.id
    msg = event.message.content.downcase.sub("<@#{bot_id}>", "")
    msg = msg.sub("?", "")
    reply = ''

    nil unless msg.split(" ").size >= 3

    load_answers if answers.length == 0

    if (/\sor\s/ =~ msg) != nil
      words = []
      msg = msg.split("\sor\s")
      msg.each do |element|
        if element.include?(",")
          words.concat(element.split(","))
        else
          words << element
        end
      end
      reply = Utilities.random_element(words)
    elsif msg.include?(",")
      reply = Utilities.random_element(msg.split(","))
    else
      reply = Utilities.random_element(@answers)
    end

    event.respond reply
  end

end
