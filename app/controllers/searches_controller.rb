class SearchesController < ApplicationController
  def new
  end

  def create
    reset_all

    if params[:format]
      topic = params[:format]
      entity = "anywhere"
    elsif params[:search]
      topic = params[:search][:topic]
      entity = params[:search][:entity].split.last.downcase
    else
      redirect_to searches_path
    end

    result = AlchemyService.new.query(topic, entity)

    if result["statusInfo"] 
      redirect_to searches_path, alert: result["statusInfo"].upcase
    else
      redirect_to searches_path, notice: generate_search(result)
    end
  end

  def index
    @articles = Article.all
    @search = Search.new
    @entities = ['anywhere', 'as a Person', 'as a City', 'as a Company', 'as an Organization']
  end

  private

  def generate_search(result)
    return no_results_found unless result["result"]

    result["result"]["docs"].each do |info|

      return no_results_found unless info["source"]["enriched"]["url"]["title"] 

      article = Article.create(
        title: info["source"]["enriched"]["url"]["title"], 
        text: info["source"]["enriched"]["url"]["text"]
      )

      unless info["source"]["enriched"]["url"]["enrichedTitle"]["keywords"].first["knowledgeGraph"]["typeHierarchy"].nil?
        create_keywords(info["source"]["enriched"]["url"]["enrichedTitle"]["keywords"].first["knowledgeGraph"]["typeHierarchy"][1..-1].split('/'), article)
      end

      unless info["source"]["enriched"]["url"]["enrichedTitle"]["entities"].nil?
        create_entities(info["source"]["enriched"]["url"]["enrichedTitle"]["entities"], article)
      end
      
    end
    "Success"
  end

  def reset_all
    Entity.delete_all
    Keyword.delete_all
    Article.delete_all
  end

  def search_params
    params.require(:search).permit(:topic, :entity)
  end

  def create_keywords(keywords, article)
    unless keywords.empty?
      keywords.each do |word|
        Keyword.create(name: word, article_id: article.id)
      end
    end
  end

  def create_entities(sub_query, article)
    sub_query.each do |ele|
      Entity.create(
        title: ele["text"], 
        ent_type: ele["type"],
        sent_score: ele["sentiment"]["score"],
        sent_type: ele["sentiment"]["type"],
        article_id: article.id
      )
    end
  end

  def no_results_found
    "No results found"
  end

end
