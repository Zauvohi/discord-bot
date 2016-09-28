module Messages
  extend Discordrb::EventContainer
  require_relative 'utilities'

  message(containing: /dumb clarisse|dumb clarise|dumb clarrise|dumb clarice/) do |event|
    clarise_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223119041269727234/1467570514071.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119071409864705/1468286308084.png",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119085767098369/1468690209357.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119116045778944/1468707091151.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119174061391875/1469303650737.jpg"
    ]
    event.respond Utilities.random_element(clarise_pics)
  end

  mention(containing: /or+|\?/) do |event|
    bot_id = event.bot.profile.id
    msg = event.message.content.downcase.sub("<@#{bot_id}>", "")
    msg = msg.sub("?", "")
    words = []

    nil unless msg.split(" ").size >= 3

    if msg.include?("or")
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
      words = ["yes", "no", "i dunno", "nope.", "lolno", "ye", "probably", "yes if you kill the HRT"]
    end

    event.respond Utilities.random_element(words)
  end
end
