#= require 'ReactPromptMixin'

component 'Navbar',

  getInitialState: ->
    accountInfo: {
      disk: {}
    }

  accountInfoChanged: ->
    setTimeout =>
      @setState accountInfo: putio.account.info

  componentDidMount: ->
    putio.account.info.on('change', @accountInfoChanged)
    putio.account.info.load()

  componentWillUnmount: ->
    putio.account.info.removeListener('change', @accountInfoChanged)

  render: ->
    {div, span, img, ActionLink, LogoutButton, FileSize, ExternalLink, TorrentSearchForm} = DOM
    {username, disk, avatar_url} = @state.accountInfo

    div(
      className: 'Navbar flex-row',

      ActionLink
        href: '/'
        img src: '//put.io/images/tinylogo.png'

      ActionLink(href: '/shows',     'Shows')
      ActionLink(href: '/transfers', 'Transfers')
      ActionLink(href: '/files',     'Files')

      TorrentSearchForm()

      div className: 'flex-spacer'

      div className: 'Navbar-username', username
      img(src: avatar_url, className: 'Navbar-avatar')

      if disk? && disk.avail?
        div
          className: 'Navbar-usage'
          FileSize(size: disk.avail)
          span(null, '/')
          FileSize(size: disk.size)

      LogoutButton(),
    )




