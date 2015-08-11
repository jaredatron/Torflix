#= require eventemitter3
#= require Object.assign
#= require Torrentz

@Torrent = class Torrent
  constructor: ->

  @search = (query) ->
    Torrentz.search(query)

  @get = (id) ->
    Torrentz.findMagnetLink(id).then (magnet_link) ->
      {
        id: id,
        magnet_link: magnet_link,
      }

  @add = (id) ->
    @get(id).then (torrent) ->
      App.putio.transfers.add torrent.magnet_link
