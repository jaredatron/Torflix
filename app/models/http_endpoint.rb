class HttpEndpoint

  def initialize(host)
    @host = URI.parse(host)
  end

  def url_for(path, params={})
    url = @host.dup
    url.path = path
    url.query = params.to_query
    url.to_s
  end

  def get(path, params={})
    url = url_for(path, params)
    response = HTTParty.get(url, query: params)
    # binding.pry unless response.code == 200
    raise response.inspect unless response.code == 200
    response.parsed_response
  rescue SocketError
    rety
  end


end