#= require 'ReactPromptMixin'

component 'Navbar',

  getInitialState: ->
    accountInfo: {
      disk: {}
    }

  accountInfoChanged: ->
    setTimeout =>
      @setState accountInfo: Putio.account.info

  componentDidMount: ->
    Putio.account.info.on('change', @accountInfoChanged)
    Putio.account.info.get()

  componentWillUnmount: ->
    Putio.account.info.removeListener('change', @accountInfoChanged)

  render: ->
    {div, span, img, ActionLink, LogoutButton, FileSize, ExternalLink} = DOM
    {username, disk, avatar_url} = @state.accountInfo

    div(
      className: 'Navbar flex-row',

      ExternalLink
        href: '//put.io'
        img src: '//put.io/images/tinylogo.png'

      ActionLink(href: '/shows',     'Shows')
      ActionLink(href: '/transfers', 'Transfers')
      

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




