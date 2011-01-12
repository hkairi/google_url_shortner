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
