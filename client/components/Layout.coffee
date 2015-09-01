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

{div} = require 'reactatron/DOM'


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
    props = @extendProps
      children: undefined

    horizontalSize = @state.horizontalSize

    navbar = Navbar shrink: 0
    sidebar = Sidebar {}

    mainContent = MainContent {},
      withStyle StyleAbsolute, @props.children

    if horizontalSize >= 1
      Layer props,
        Rows
          style:
            flexGrow: 1
            overflow: 'hidden'
          navbar
          Columns
            style:
              flexGrow: 1
              flexShrink: 1
              overflow: 'hidden'
            sidebar
            mainContent
    else
      Layer props,
        Rows grow: 1,
          navbar
          sidebar
          mainContent


MainContent = Block.withStyle 'MainContent',
  position: 'relative'
  flexGrow: 1
  flexShrink: 1


Navbar = component 'Navbar',

  defaultStyle:
    backgroundColor: 'black'
    color: 'white'
    padding: '0.25em'

  render: ->
    Block @cloneProps(), 'Torflix'

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
  tabIndex: -1
  style:
    backgroundColor: 'rgb(0, 59, 95)'
    padding: '0.5em'
    ':hover':
      backgroundColor: 'rgb(0, 73, 117)'
    ':focus':
      backgroundColor: 'rgb(0, 73, 117)'
