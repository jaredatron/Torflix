#= require Object.assign

Putio.File = class

  constructor: (props) ->
    Object.assign(this, props)
    @put_io_url     = "https://put.io/file/#{@id}"
    @download_url   = "https://put.io/v2/files/#{@id}/download"
    @mp4_stream_url = "https://put.io/v2/files/#{@id}/mp4/stream"
    @stream_url     = "https://put.io/v2/files/#{@id}/stream"
    @playlist_url   = "https://put.io/v2/files/#{@id}/xspf"
    @chromecast_url = "https://put.io/file/#{@id}/chromecast"
