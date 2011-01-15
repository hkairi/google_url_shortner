require "rubygems" 
require "httparty" 
# Google::UrlShortner::Analytics
module Google  
  module UrlShortner
    class Analytics
      attr_reader :visitors,       
                  :browsers,
                  :countries,
                  :platforms,
                  :long_url
      
      def initialize( url="" )        
        return {} if url == ""
        resp           ||= Request.get("/urlshortener/v1/url?shortUrl=#{url}&projection=FULL")
        @analytics     ||= resp['analytics']['allTime'] if resp
        
        @long_url        = url 
        @visitors        = @analytics['shortUrlClicks'].to_i if @analytics
        @browsers        = @analytics['browsers'] if @analytics
        @countries       = @analytics['countries'] if @analytics
        @platforms       = @analytics['platforms'] if @analytics
        [@long_url]
      end
    end
  end
end
# Google::UrlShortner::Client
module Google  
  module UrlShortner
    class Client
      attr_reader :long_url, :short_url
      #Création d'un nouveau client.
      def initialize
        @short_url = @long_url = nil 
      end
      # Crée la short url d'un site donné.
      def shorten(url)
        Google::Shortner.new(url)
      end
      # Retrouve ou retourne l'url d'un site donné à partir du "short_url"
      def expand(url)
        Google::Expander.new(url)
      end
    end
  end
end
# Google::UrlShortner::Expander
module Google  
  class Expander
    attr_accessor :short_url, :long_url  
    def initialize( short_url="" )
      return nil if !short_url.blank?
      rep = Request.get("/urlshortener/v1/url?shortUrl=#{short_url}")
      if rep.code == 200
        self.long_url  = rep['longUrl']
        self.short_url = short_url
      else
        rep.response
      end
    end
  end
end
# Google::UrlShortner::Shortner
module Google  
  class Shortner        
    attr_accessor :short_url, :long_url
    def initialize(long_url)
      options = {"longUrl" => long_url}.inspect
      resp = Request.post('/urlshortener/v1/url', :body => options)
      if resp.code == 200            
        self.short_url = resp['id']
        self.long_url  = resp['longUrl']        
      else
        resp.response
      end
    end    
  end 
end
# Google::UrlShortner::Resquest
class Request
  include HTTParty
  base_uri 'https://www.googleapis.com'
  headers 'Content-Type' => 'application/json'
  headers "Content-length" => "0"
end