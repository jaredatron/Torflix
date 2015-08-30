Putio = require '../Putio'

module.exports = (app) ->

  if matches = location.hash.match(/^#access_token=(.*)$/)
    app.set put_io_access_token: matches[1]
    app.clearHash()


  update = ->
    app.putio.setToken app.get('put_io_access_token')

  app.putio = new Putio(app)
  app.sub 'store:change:put_io_access_token', update
  update()


  # update = ->
  #   app.putio.OAUTH_TOKEN = token = app.get('put_io_access_token')
  #   app.putio.URI = URI = URI("https://api.put.io/?oauth_token=#{token}")


  # # STREAM_AUTH_TOKEN = 'WE NEED TO GET THIS FROM THE API???'


  # # This should probably go in another file




  # putioUrl = (path) ->
  #   URI.serialize
  #     scheme : "https",
  #     host: 'api.put.io'

  #   "https://api.put.io/v2/#{path}?oauth_token=#{OAUTH_TOKEN}"
  #   files/302821462



