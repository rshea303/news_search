require 'uri'

class AlchemyService
  attr_reader :count

  def initialize
    @count = 0
  end
  
  def query(topic, entity)
    Faraday.default_adapter = :excon

    uri = URI.escape("https://access.alchemyapi.com/calls/data/GetNews?apikey=#{ENV['API_KEY']}")

    search_params = %w(enriched.url.title
                       enriched.url.url
                       enriched.url.enrichedTitle.docSentiment
                       enriched.url.enrichedTitle.taxonomy
                       enriched.url.enrichedTitle.entities
                       enriched.url.enrichedTitle.keywords
                       enriched.url.text)

    response = Faraday.get(uri) do |faraday|
      faraday.params["return"]                      = search_params.join(',')
      faraday.params["start"]                       = "now-5d"
      faraday.params["end"]                         = "now"

      if entity != "anywhere"
        faraday.params["q.enriched.url.enrichedTitle.entities.entity"] = "|text=#{topic},type=#{entity}|"
      else
        faraday.params["q.enriched.url.cleanedTitle"] = "#{topic}"
      end

      faraday.params["count"]                       = "3"
      faraday.params["outputMode"]                  = "json"
    end

    if !JSON.parse(response.body)["result"] && count < 3 
      @count += 1
      query(topic, entity)
    else
      JSON.parse(response.body)
    end
  end
 
end
