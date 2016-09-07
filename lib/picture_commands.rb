module PictureCommands
  extend Discordrb::Commands::CommandContainer
  require_relative 'utilities'

  command(:stick, chain_usable: false) do |event|
    event.respond "https://cdn.discordapp.com/attachments/190607069093691393/222907225809747968/a_fucking_stick_lamo.png"
  end

  command(:otsu, chain_usable: false) do |event|
    event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223097379279208449/8KzSio.png"
  end

  command(:snek, chain_usable: false) do |event|
    snek_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223110760073527307/1472435078016.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223113005326532608/1471425508841.png",
      "https://cdn.discordapp.com/attachments/222920939598381060/223113038935490560/1472958217093.png"
    ]
    event.respond Utilities.random_pic(snek_pics)
  end

  command(:windmeme, chain_usable: false) do |event|
    wind_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223112000249528321/windmeme2.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223112027575549953/windmeme3.png",
      "https://cdn.discordapp.com/attachments/222920939598381060/223111938463367168/1465766595855.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223112048224108545/wind_memers.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223116810612899840/1466962326898.jpg"
    ]
    event.respond Utilities.random_pic(wind_pics)
  end

  command(:sen, chain_usablem: false) do |event|
    sen_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223117869427195904/1470513276648.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223115601932058624/SEN.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223117884866560000/1470513527971.jpg"
    ]
    event.respond Utilities.random_pic(sen_pics)
  end

  command(:police, chain_usable: false) do |event|
    event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223115777367212037/police.jpg"
  end
end
