component = require 'reactatron/component'
styledComponent = require 'reactatron/styledComponent'
Block     = require 'reactatron/Block'
Box     = require 'reactatron/Box'
Layer     = require 'reactatron/Layer'
Rows      = require 'reactatron/Rows'
Columns   = require 'reactatron/Columns'
Text      = require 'reactatron/Text'
Link      = require 'reactatron/Link'

# Sidebar = require './Sidebar'

module.exports = component 'Layout',

  dataBindings: ['horizontalSize']

  defaultStyle:
    userSelect: 'none'
    WebkitUserSelect: 'none'

  render: ->
    horizontalSize = @state.horizontalSize

    navbar = Navbar shrink: 0

    mainContent = MainContent {}, @props.children

    if horizontalSize >= 1
      Layer @cloneProps(),
        Rows grow: 1,
          navbar
          Columns grow: 1, shrink: 1,
            Sidebar {}
            mainContent
    else
      Layer @cloneProps(),
        Rows grow: 1,
          navbar
          Sidebar {}
          mainContent


MainContent = Box.extendStyledComponent 'MainContent',
  flexGrow: 1
  flexShrink: 1
  overflowY: 'auto'


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

  render: ->
    Rows @cloneProps(),
      SidebarLink path: '/transfers', 'Transfers'
      SidebarLink path: '/shows',     'Shows'
      SidebarLink path: '/files',     'Files'
      SidebarLink path: '/bookmarks', 'Bookmarks'


SidebarLink = styledComponent 'SidebarLink', Link,
  backgroundColor: 'rgb(0, 59, 95)'
  padding: '0.5em'
  ':hover':
    backgroundColor: 'rgb(0, 73, 117)'
  ':focus':
    backgroundColor: 'rgb(0, 73, 117)'

