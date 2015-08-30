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

module.exports = component 'Layout',

  dataBindings: ['horizontalSize']

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


    child = @props.children[0]
    style = new Style(child.props.style).merge
      position: 'absolute'
      top: 0
      left: 0
      bottom: 0
      right: 0
    child = React.cloneElement(child, style: style)


    # child = React.addons.cloneWithProps(child, {style: {color: 'blue'}});

    mainContent = MainContent {}, child

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
  # overflowY: 'auto'


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
      SidebarLink path: '/transfers', params: {}, tabIndex: -1, 'Transfers'
      SidebarLink path: '/shows',     params: {}, tabIndex: -1, 'Shows'
      SidebarLink path: '/files',     params: {}, tabIndex: -1, 'Files'
      SidebarLink path: '/bookmarks', params: {}, tabIndex: -1, 'Bookmarks'
      SidebarLink onClick: @logout, tabIndex: -1, 'Logout'


SidebarLink = Link.withStyle 'SidebarLink',
  backgroundColor: 'rgb(0, 59, 95)'
  padding: '0.5em'
  ':hover':
    backgroundColor: 'rgb(0, 73, 117)'
  ':focus':
    backgroundColor: 'rgb(0, 73, 117)'

