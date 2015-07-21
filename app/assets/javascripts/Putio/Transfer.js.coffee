#= require Object.assign

Putio.Transfer = class

  constructor: (props) ->
    Object.assign(this, props)
    @isComplete    = @finished_at?
    @isDownloading = "DOWNLOADING" == @status

  file: ->
    App.putio.files.get(@file_id)