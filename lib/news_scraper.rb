class NewsScraper
  require 'net/http'
  require 'uri'
  require 'nokogiri'

  attr_accessor :info

  def initialize(minutes = 0)
    @interval = minutes
    @info = nil
  end

  def get_news
    site = 'http://www.granbluefantasy.jp/news/index.php'
    page = Net::HTTP.get_response(URI.parse("#{site}"))
    parsed_page = Nokogiri::HTML(page.body)

    info = {}
    post = parsed_page.css('article').first
    date = post.css('.date').children.first.text

    info[:title] = post.css('.change_news_trigger').text
    info[:link] = post.css('.change_news_trigger').attribute('href').value
    info[:date] = DateTime.parse(date)

    info
  end

  def update
    @info = get_news
  end

  def lastest
    msg = %Q(
    Lastest post: #{@info[:title]}
    Date: #{@info[:date].strftime('%d/%m/%y   %I:%M %p')} JST
    Link: #{@info[:link]}
    )
    msg
  end

  def is_recent?(post)
    post[:date] > @info[:date]
  end

end
