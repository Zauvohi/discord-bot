module Messages
  extend Discordrb::EventContainer
  require_relative 'utilities'

  message(containing: /dumb clar+i*(c+|s+)e+/) do |event|
    clarise_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223119041269727234/1467570514071.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119071409864705/1468286308084.png",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119085767098369/1468690209357.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119116045778944/1468707091151.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223119174061391875/1469303650737.jpg"
    ]
    event.respond Utilities.random_element(clarise_pics)
  end

  message(containing: /mo+d+s+/i) do |event|
    pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/236266183140048896/HorribleSubs_Amaama_to_Inazuma_-_08_720p.mkv_snapshot_13.36_2016.09.11_00.56.51.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/236234989501415424/HorribleSubs_Amaama_to_Inazuma_-_07_720p.mkv_snapshot_13.51_2016.09.09_02.33.07.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/236266391769055233/HorribleSubs_Amaama_to_Inazuma_-_06_720p.mkv_snapshot_06.11_2016.09.09_01.57.22.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/236266436111237120/HorribleSubs_Amaama_to_Inazuma_-_06_720p.mkv_snapshot_06.24_2016.09.09_01.57.49.jpg"
    ]

    event.respond "MOOOODDS"
    event.respond Utilities.random_element(pics)

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
      words = ["yes", "no", "i dunno", "nope.", "lolno", "ye", "probably", "yes, but you have to kill HRT"]
    end

    event.respond Utilities.random_element(words)
  end
end
