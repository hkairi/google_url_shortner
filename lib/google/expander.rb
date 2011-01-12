module Google

  class Expander

    attr_accessor :long_url

    def initialize(short_url)
      rep = Request.get("/urlshortener/v1/url?shortUrl=#{short_url}")
      if rep.code == 200
        self.long_url   = rep['longUrl']
      else
        rep.response
      end
    end

  end

end
