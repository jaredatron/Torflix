React      = require 'react'
component  = require '../component'
ActionLink = require './ActionLink'
FileSize   = require './FileSize'

{div, span, img } = React.DOM

module.exports = component 'DashboardControls',

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

    {username, disk} = @state.accountInfo

    div(
      className: 'DashboardControls flex-row',

      div className: 'DashboardControls-username', username

      div className: 'flex-spacer'
      img src: '//put.io/images/tinylogo.png'
      div className: 'flex-spacer'

      div
        className: 'DashboardControls-usage'
        FileSize(size: disk.avail)
        span(null, ' free of ')
        FileSize(size: disk.size)

      LogoutButton(),
    )


LogoutButton = component 'LogoutButton',

  logout: (event) ->
    event.preventDefault()
    session('put_io_access_token', null)

  render: ->
    ActionLink onClick: @logout, 'Logout'



