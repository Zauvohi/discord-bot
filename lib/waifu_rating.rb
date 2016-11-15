module WaifuRating
  extend Discordrb::Commands::CommandContainer
  require_relative 'utilities'

  @trash_comments = [
    "your waifu is trash lamo",
    ":poop:",
    "literally garbage",
    "tfw this guy has shit taste",
    "at least it's not Mio"
  ]

  @harsh_comments = [
    ":thinking:",
    "buddy pls",
    "could be worse (like mio aoaoaoa)"
  ]

  @nice_comments = [
    "nice taste :ok_hand:",
    ":ok_hand:"
  ]

  @ten_comments = [
    ":weary: :ok_hand:",
    ":100: :100: :100: :100: :ok_hand:",
    "based taste"
  ]

  @sacred_waifus = [
    "Korwa",
    "Kurwa",
    "Sen",
    "Shibuya Rin",
    "Rin",
    "Jougasaki Mika",
    "Mika",
    "Narumeia",
    "Naru",
    "Kanzaki Ranko",
    "Ranko",
    "Kamiya Nao",
    "Nao",
    "Hojo Karen",
    "Karen",
    "Monki",
    "Andira",
    "Anchira",
    "Anila",
    "Anira",
    "Tamamo no mae",
    "Tamamo",
    "Casko",
    "Elizabeth Bathory",
    "Elizabeth",
    "Liz",
    "Futaba Anzu",
    "Anzu"
  ]

  def self.is_sacred?(waifu)
    waifus_regex = Regexp.new(@sacred_waifus.join("|"), true)
    waifus_regex.match(waifu) != nil
  end

  command(:ratewaifu, chain_usable:  false) do |event, *waifu|
    waifu = waifu.join(" ")
    alt_waifu = /me|myself/i != nil ? "you" : waifu
    score = self.is_sacred?(waifu) ? 11 : rand(10)
    msg = ":thinking: I would rate #{alt_waifu}... #{score}/10 "


    if /mio|honda mio/i.match(waifu) != nil
      msg = ">waifuing mio \n pls :boot:"
    elsif /tsumugi|you|yourself|this bot/i.match(waifu) != nil
      msg = "I'm the cutest! :relaxed:"
    elsif score >= 10
      msg += Utilities.random_element(@ten_comments)
    elsif score.between?(7, 9)
      msg += Utilities.random_element(@nice_comments)
    elsif score.between?(4, 6)
      msg += Utilities.random_element(@harsh_comments)
    else
      msg += Utilities.random_element(@trash_comments)
    end

    event.respond msg
  end
end
