module WaifuRating
  extend Discordrb::Commands::CommandContainer
  require_relative 'utilities'

  @trash_comments = [
    "your waifu is trash lamo",
    ":poop:",
    "literally garbage",
    "tfw this guy has shit taste",
    "at least it's not Mio",
    "can you like, get better taste?",
    "would not hold hands with",
    "can you stop having such a bad taste",
    "... \n http://i.imgur.com/iPR2j5H.jpg"
  ]

  @harsh_comments = [
    ":thinking:",
    "buddy pls",
    "could be worse (like mio aoaoaoa)",
    "it's not mio, but... it's ok i guess",
    "eh...",
    "http://i.imgur.com/Z4ZxPlx.jpg",
    "i mean, yeah i guess it's ok for you \n http://i.imgur.com/AOCvQjl.jpg"
  ]

  @nice_comments = [
    "nice taste :ok_hand:",
    ":ok_hand:",
    "would hold hands with",
    "http://i.imgur.com/wquVBPP.png"
  ]

  @ten_comments = [
    ":weary: :ok_hand:",
    ":100: :100: :100: :100: :ok_hand:",
    "patrician taste",
    "muh nig",
    "http://i.imgur.com/GmP1JiN.jpg",
    "goddamn http://i.imgur.com/kP2KwBI.png",
    "http://i.imgur.com/gIlc48T.jpg",
    "http://i.imgur.com/J3ACDqh.png"
  ]

  @sacred_waifus = [
    'Korwa',
    'Kurwa',
    'Sen',
    'Shibuya Rin',
    'Rin',
    'Jougasaki Mika',
    'Mika',
    'Narumeia',
    'Naru',
    'Kanzaki Ranko',
    'Ranko',
    'Kamiya Nao',
    'Nao',
    'Hojo Karen',
    'Karen',
    'Monki',
    'Andira',
    'Anchira',
    'Anila',
    'Anira',
    'Tamamo no mae',
    'Tamamo',
    'Casko',
    'Elizabeth Bathory',
    'Elizabeth',
    'Liz',
    'Futaba Anzu',
    'Anzu',
    'Danua',
    'Orchid',
    'Orchis',
    'Shoebill',
    'Bea',
    'Beatrix',
    'Yuisis',
    'Anthuria',
    'Yuel',
    'Sochie'
  ]

  def self.is_sacred?(waifu)
    waifus_regex = Regexp.new(@sacred_waifus.join("|"), true)
    waifus_regex.match(waifu) != nil
  end

  command(:ratewaifu, chain_usable:  false) do |event, *waifu|
    waifu = waifu.join(" ")
    alt_waifu = /\sme\s|\smyself\s/i.match(waifu) != nil ? "you" : waifu
    score = self.is_sacred?(waifu) ? 11 : rand(10)
    msg = ":thinking: I would rate #{alt_waifu}... #{score}/10 "

    if /mio|honda mio/i.match(waifu)
      msg = ">waifuing mio \n pls :boot:"
    elsif /emilia|emiria|emt/i.match(waifu)
      emt = [
        "11/10 E M T",
        "E\nM\nT",
        "11/10 Ｅ・Ｍ・Ｔ！！ Emilia-tan Maji Tenshi!",
        "Ｅ・Ｍ・Ｔ！！\nhttp://i.imgur.com/TZwUnea.png"
      ]
      msg = Utilities.random_element(emt)
    elsif /tsumugi|you|yourself|this bot/i.match(waifu)
      qtbot = [
        "I'm the cutest! :relaxed:",
        "http://i.imgur.com/CgvPAva.jpg",
        "http://i.imgur.com/cXaEQ30.jpg"
      ]
      msg = Utilities.random_element(qtbot)
    elsif score >= 10
      msg << Utilities.random_element(@ten_comments)
    elsif score.between?(7, 9)
      msg << Utilities.random_element(@nice_comments)
    elsif score.between?(4, 6)
      msg << Utilities.random_element(@harsh_comments)
    else
      msg << Utilities.random_element(@trash_comments)
    end

    event.respond msg
  end
end
