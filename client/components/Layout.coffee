component = require 'reactatron/component'
Block     = require 'reactatron/Block'
Box     = require 'reactatron/Box'
Layer     = require 'reactatron/Layer'
Rows      = require 'reactatron/Rows'
Columns   = require 'reactatron/Columns'
Text      = require 'reactatron/Text'
Link      = require 'reactatron/Link'

{div} = require 'reactatron/DOM'

# Sidebar = require './Sidebar'


MagicBox = Block.withStyle 'MagicBox',
  height: '100px'
  width: '100px'
  background: 'teal'
  color: 'black'
  ':hover':
    background: 'orange'
    color: 'purple'
  ':mousedown':
    background: 'yellow'
    color: 'red'


module.exports = component 'Layout',

  dataBindings: ['horizontalSize']

  defaultStyle:
    userSelect: 'none'
    WebkitUserSelect: 'none'

  render: ->
    props = @extendProps
      children: undefined

    # return Layer props,
    #   Columns grow: 1,
    #     MagicBox {}, 'LOVE ME'
    #     MagicBox {}, 'SHOES'
    #     MagicBox {}, 'Life'
    #     MagicBox {}, 'COWS'

    horizontalSize = @state.horizontalSize

    navbar = Navbar shrink: 0
    sidebar = Sidebar {}

    mainContent = MainContent {}, @props.children

    if horizontalSize >= 1
      Layer props,
        Rows grow: 1,
          navbar
          Columns grow: 1, shrink: 1,
            sidebar
            mainContent
    else
      Layer props,
        Rows grow: 1,
          navbar
          sidebar
          mainContent


MainContent = Box.withStyle 'MainContent',
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


SidebarLink = Link.withStyle 'SidebarLink',
  backgroundColor: 'rgb(0, 59, 95)'
  padding: '0.5em'
  ':hover':
    backgroundColor: 'rgb(0, 73, 117)'
  ':focus':
    backgroundColor: 'rgb(0, 73, 117)'

