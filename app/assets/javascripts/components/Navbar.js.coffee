#= require 'ReactPromptMixin'

component 'Navbar',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    accountInfo: {
      disk: {}
    }

  accountInfoChanged: ->
    setTimeout =>
      @setState accountInfo: @context.putio.account.info

  componentDidMount: ->
    @context.putio.account.info.on('change', @accountInfoChanged)
    @context.putio.account.info.get()

  componentWillUnmount: ->
    @context.putio.account.info.removeListener('change', @accountInfoChanged)

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

      div
        className: 'Navbar-usage'
        FileSize(size: disk.avail)
        span(null, '/')
        FileSize(size: disk.size)

      LogoutButton(),
    )




