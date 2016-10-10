module PictureCommands
  extend Discordrb::Commands::CommandContainer
  require_relative 'utilities'

  bucket :pics, limit: 5, time_span: 10, delay: 2

  command(:stick,
    chain_usable: false,
    bucket: :pics
  ) do |event|
    event.respond "https://cdn.discordapp.com/attachments/190607069093691393/222907225809747968/a_fucking_stick_lamo.png"
  end

  command(:otsu,
    chain_usable: false,
    bucket: :pics
  ) do |event|
    event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223097379279208449/8KzSio.png"
  end

  command(:snek,
    chain_usable: false,
    bucket: :pics
  ) do |event|
    snek_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223110760073527307/1472435078016.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223113038935490560/1472958217093.png",
      "https://cdn.discordapp.com/attachments/222920939598381060/223113005326532608/1471425508841.png",
    ]
    pic = ""

    if (rand(0 .. 10000) === 777)
      pic = "https://cdn.discordapp.com/attachments/222920939598381060/223225019856191488/dagger.png"
    else
      pic = Utilities.random_element(snek_pics)
    end
    event.respond pic
  end

  command(:windmeme,
    chain_usable: false,
    bucket: :pics
  ) do |event|
    wind_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223112000249528321/windmeme2.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223112027575549953/windmeme3.png",
      "https://cdn.discordapp.com/attachments/222920939598381060/223111938463367168/1465766595855.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223112048224108545/wind_memers.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223116810612899840/1466962326898.jpg",
      "https://cdn.discordapp.com/attachments/190607069093691393/232585721163153408/windmemes6.jpg"
    ]
    event.respond Utilities.random_element(wind_pics)
  end

  command(:sen,
    chain_usable: false,
    bucket: :pics
  ) do |event|
    sen_pics = [
      "https://cdn.discordapp.com/attachments/222920939598381060/223117869427195904/1470513276648.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223115601932058624/SEN.jpg",
      "https://cdn.discordapp.com/attachments/222920939598381060/223117884866560000/1470513527971.jpg"
    ]
    event.respond Utilities.random_element(sen_pics)
  end

  command(:police,
    chain_usable: false,
    bucket: :pics
  ) do |event|
    event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223115777367212037/police.jpg"
  end
end
