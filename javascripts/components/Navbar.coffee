component = require 'reactatron/component'
{a, div, img} = require 'reactatron/DOM'
ColumnContainer = require './ColumnContainer'
FileSize = require './FileSize'

module.exports = component 'Navbar',

  getDataBindings: ->
    ['accountInfo']

  componentDidMount: ->
    @app.pub 'load accountInfo'

  render: ->
    ColumnContainer null,
      a
        href: '/'
        className: 'Navbar-logo'
        img src: '//put.io/images/tinylogo.png'

      a href: '/transfers', 'Transfers'
      a href: '/files',     'Files'
      a href: '/shows',     'Shows'
      # div null, JSON.stringify(@data.accountInfo)

      if @data.accountInfo?
        AccountInfo(@data.accountInfo)



AccountInfo = component 'Navbar.AccountInfo',
  render: ->
    ColumnContainer null,
      img(src: @props.avatar_url, className: 'Navbar-avatar')
      if @props.disk? && @props.disk.avail?
        div
          className: 'Navbar-usage'
          FileSize(size: @props.disk.avail)
          '/'
          FileSize(size: @props.disk.size)

  # getInitialState: ->
  #   accountInfo: {
  #     disk: {}
  #   }

  # accountInfoChanged: ->
  #   setTimeout =>
  #     @setState accountInfo: App.putio.account.info

  # componentDidMount: ->
  #   App.putio.account.info.on('change', @accountInfoChanged)
  #   App.putio.account.info.load()

  # componentWillUnmount: ->
  #   App.putio.account.info.removeListener('change', @accountInfoChanged)

  # render: ->
  #   {a, div, span, img, ActionLink, LogoutButton, FileSize, ExternalLink, TorrentSearchForm, Glyphicon} = DOM
  #   {username, disk, avatar_url} = @state.accountInfo

  #   div(
  #     className: 'Navbar flex-row',

  #     ActionLink
  #       href: '/'
  #       className: 'Navbar-logo'
  #       img src: '//put.io/images/tinylogo.png'

  #     ActionLink(href: '/transfers', 'Transfers')
  #     ActionLink(href: '/files',     'Files')
  #     ActionLink(href: '/shows',     'Shows')

  #     TorrentSearchForm()

  #     div className: 'flex-spacer'

  #     div className: 'Navbar-username', username
  #     img(src: avatar_url, className: 'Navbar-avatar')

  #     a
  #       href: "/Torflix-chrome-extension.crx"
  #       download: true
  #       Glyphicon glyph: 'cog'

  #     if disk? && disk.avail?
  #       div
  #         className: 'Navbar-usage'
  #         FileSize(size: disk.avail)
  #         span(null, '/')
  #         FileSize(size: disk.size)

  #     LogoutButton(),
  #   )




