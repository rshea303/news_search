require 'hurley'

class AlchemyService
  attr_reader :connection

  def initialize
    @connection = Hurley::Client.new("https://access.alchemyapi.com/calls/data/GetNews?apikey=#{ENV["API_KEY"]}&outputMode=json&start=now-1d&end=now&maxResults=15&return=enriched.url.title,enriched.url.text")
  end

  def articles
    connection.get('articles')
  end
end
