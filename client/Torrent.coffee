Torrentz = require './Torrentz'

module.exports =

  search: (query) ->
    Torrentz.search(query)

  get: (id) ->
    Torrentz.findMagnetLink(id).then (magnet_link) ->
      {
        id: id,
        magnet_link: magnet_link,
      }
