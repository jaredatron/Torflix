React = require 'react'
Style = require 'reactatron/Style'
component = require 'reactatron/component'
Block     = require 'reactatron/Block'
Box       = require 'reactatron/Box'
Layer     = require 'reactatron/Layer'
Rows      = require 'reactatron/Rows'
Columns   = require 'reactatron/Columns'
Text      = require 'reactatron/Text'
Link      = require 'reactatron/Link'
withStyle = require 'reactatron/withStyle'


StyleAbsolute = new Style
  position: 'absolute'
  top: 0
  left: 0
  bottom: 0
  right: 0

module.exports = component 'Layout',

  dataBindings: ->
    horizontalSize: 'horizontalSize'

  defaultStyle:
    userSelect: 'none'
    WebkitUserSelect: 'none'
    fontFamily: "'Helvetica Neue', Helvetica, Arial, sans-serif"
    fontSize: '15px'

  render: ->
    horizontalSize = @state.horizontalSize

    sidebar = Sidebar {}

    mainContent = MainContent
      key: 'MainContent'
      withStyle StyleAbsolute, @props.children

    Layer @cloneProps(),
      MainContentWrapper
        style:
          flexDirection: if horizontalSize >= 1 then 'row' else 'column'
        sidebar
        mainContent


MainContentWrapper = Rows.withStyle 'MainContentWrapper',
  flexGrow: 1
  overflow: 'hidden'

MainContent = Block.withStyle 'MainContent',
  position: 'relative'
  flexGrow: 1
  flexShrink: 1



Sidebar = component 'Sidebar',

  defaultStyle:
    backgroundColor: 'black'
    color: 'white'

  logout: (event) ->
    # event.preventDefault()
    @app.logout()

  render: ->
    Rows @cloneProps(),
      SidebarLink path: '/transfers', params: {}, 'Transfers'
      SidebarLink path: '/search',    params: {}, 'Search'
      SidebarLink path: '/shows',     params: {}, 'Shows'
      SidebarLink path: '/files',     params: {}, 'Files'
      SidebarLink path: '/bookmarks', params: {}, 'Bookmarks'
      SidebarLink onClick: @logout,   'Logout'


SidebarLink = Link.withDefaultProps
  style:
    outline: 'none'
    fontWeight: 100
    backgroundColor: 'rgb(0, 59, 95)'
    padding: '0.5em'
    ':hover':
      backgroundColor: 'rgb(0, 73, 117)'
    ':focus':
      backgroundColor: 'rgb(0, 73, 117)'
