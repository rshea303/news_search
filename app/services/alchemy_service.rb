class AlchemyService
  attr_reader :connection

  def initialize
    @connection = Hurley::Client.new("https://access.alchemyapi.com/calls/data/GetNews?apikey=#{ENV[API_KEY]}&outputMode=json")
  end

  def articles
    connection.get('articles')
  end
end
