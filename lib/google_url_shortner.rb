require 'rubygems'
require 'httparty'

require 'google/request'
require 'google/shortner'
require 'google/expander'

module Google

  def self.shorten(url)
    Google::Shortner.new(url)
  end

  def self.expand(url)
    Google::Expander.new(url)
  end

end
