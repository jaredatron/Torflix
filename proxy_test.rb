require 'httparty'


ENV['PROXY_HOST'] = 'FREE-CA.HIDE.ME'
ENV['PROXY_USERNAME'] = 'deadlyicon'
ENV['PROXY_PASSWORD'] = '2EgfrAP4ezaErJ'

# HTTParty.get('https://torrentz.com/search?q=The+Daily+Show')


class Torrentz
  include HTTParty
  base_uri 'http://google.com'
  http_proxy "64.213.148.50", 8080
  # logger Rails.logger

  def search query
    get('')
  end
end

puts Torrentz.get('/search?q=The+Daily+Show').body
