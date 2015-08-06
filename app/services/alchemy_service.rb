require 'uri'

class AlchemyService
  
  def query(topic, entity)
    Faraday.default_adapter = :excon

    uri = Addressable::URI.parse("https://access.alchemyapi.com/calls/data/GetNews?apikey=#{ENV['API_KEY']}")

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

      faraday.params["count"]                       = "15"
      faraday.params["outputMode"]                  = "json"
    end

    JSON.parse(response.body)
  end
end
