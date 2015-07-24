class HttpEndpoint

  def initialize(host)
    @host = URI.parse(host)
  end

  def url_for(path, params={})
    url = @host.dup
    url.path = path
    url.query = params.blank? ? nil : params.to_query
    url.to_s
  end

  def get(path, params={})
    url = url_for(path, params)
    Rails.logger.info("GET #{url}")
    response = HTTParty.get(url, query: params)
    # Rails.logger.info("Response: #{response.code}")
    # binding.pry unless response.code == 200
    raise response.inspect unless response.code == 200
    response.parsed_response
  rescue SocketError
    retry
  end


end