module PictureCommands
  extend Discordrb::Commands::CommandContainer

  command(:stick, chain_usable: false) do |event|
    event.respond "https://cdn.discordapp.com/attachments/190607069093691393/222907225809747968/a_fucking_stick_lamo.png"
  end

  command(:otsu, chain_usable: false) do |event|
    event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223097379279208449/8KzSio.png"
  end
end
