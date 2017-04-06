module Messages
  extend Discordrb::EventContainer
  require_relative 'utilities'

  message(containing: /dumb clar+i*(c+|s+)e+/) do |event|
    clarise_pics = [
      "http://i.imgur.com/SVR6WMO.jpg",
      "http://i.imgur.com/RzOg0tr.png",
      "http://i.imgur.com/PW1LmeR.jpg",
      "http://i.imgur.com/xPscDma.png",
      "http://i.imgur.com/paiYnhF.jpg"
    ]
    event.respond Utilities.random_element(clarise_pics)
  end

  mention(containing: /\sor\s+|\?/) do |event|
    bot_id = event.bot.profile.id
    msg = event.message.content.downcase.sub("<@#{bot_id}>", "")
    msg = msg.sub("?", "")
    words = []

    nil unless msg.split(" ").size >= 3

    if (/\sor\s/ =~ msg) != nil
      msg = msg.split("or")
      msg.each do |element|
        if element.include?(",")
          words.concat(element.split(","))
        else
          words << element
        end
      end
    elsif msg.include?(",")
      words = msg.split(",")
    else
      words = [
        "yes", "no", "i dunno", "nope.", "lolno",
        "ye", "probably", "yes, but you have to bring back HRT",
        "Yes, but I'll need a blood sacrifice.",
        "no, keep dreaming lamo",
        "only if you accept KMR as your lord and savior.",
        "everytime you ask this i die a little",
        "i really don't know \n http://i.imgur.com/ytBUX9g.jpg",
        "you can keep asking but both of us know the answer \n http://i.imgur.com/Z7R9VZv.jpg", "http://i.imgur.com/xyGMHGz.jpg", "http://i.imgur.com/NFO2KMb.png",
        "yeah dude, whatever lets you sleep at night \n http://i.imgur.com/6QBnkdB.jpg", "everything is possible if you believe in magic my dude\n http://i.imgur.com/Ub5EDlm.jpg"
      ]
    end

    event.respond Utilities.random_element(words)
  end

end
