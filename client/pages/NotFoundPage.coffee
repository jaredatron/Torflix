component = require 'reactatron/component'
Block = require 'reactatron/Block'
Layer = require 'reactatron/Layer'
Rows = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
# Layout = require '../components/Layout'

module.exports = component 'NotFoundPage',

  # render: ->
  #   Layout {}, 'Page Not Found'

  render: ->
    Layer {},
      Rows grow: 1, style: {background: 'red'},
        Block style:{background: 'purple'}, 'Navbar here'
        Columns grow: 1, style:{background: 'green'},
          Block style:{background: 'teal'}, 'Sidebar here'
          Block grow: 1, style:{background: 'orange'}, 'main content'
          Block grow: 2, style:{background: 'brown'}, 'main content 2'

        Columns grow: 1, style:{background: 'salmon'},
          Block style:{background: 'blue'}, 'Sidebar here'
          Block grow: 1, style:{background: 'yellow'}, 'main content'


      # Rows style:{outline:'1px solid purple'},
      #   Block style:{outline:'1px solid red'}, 'A'
      #   Block style:{outline:'1px solid red'}, 'B'
      #   Block style:{outline:'1px solid red'}, 'C'
      #   Block style:{outline:'1px solid red'}, 'D'

      # Columns style:{outline:'1px solid green'},
      #   Block style:{outline:'1px solid red'}, 'A'
      #   Block style:{outline:'1px solid red'}, 'B'
      #   Block style:{outline:'1px solid red'}, 'C'
      #   Block style:{outline:'1px solid red'}, 'D'

      # Rows style:{outline:'1px solid purple'},
      #   Block style:{outline:'1px solid red'}, 'A'
      #   Block style:{outline:'1px solid red'}, 'B'
      #   Block style:{outline:'1px solid red'}, 'C'
      #   Block style:{outline:'1px solid red'}, 'D'




getRandomColor = ->
  letters = '0123456789ABCDEF'.split('')
  color = '#'
  i = 6
  while i--
    color += letters[Math.floor(Math.random() * 16)];
  color
