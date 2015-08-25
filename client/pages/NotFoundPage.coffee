component = require 'reactatron/component'
Block = require 'reactatron/Block'
Layer = require 'reactatron/Layer'
Rows = require 'reactatron/Rows'
Columns = require 'reactatron/Columns'
Text = require 'reactatron/Text'
# Layout = require '../components/Layout'

module.exports = component 'NotFoundPage',

  # render: ->
  #   Layout {}, 'Page Not Found'

  render: ->
    Layer {},
      Rows grow: 1, style: {background: 'red'},
        Block shrink: 0, style:{background: 'purple'}, 'Navbar here'
        Columns grow: 1, style:{background: 'green'},
          Block minWidth: '200px', style:{background: 'teal'}, 'Sidebar here'

          Rows grow: 1, overflowY: 'auto', style:{background: 'orange'},

            # Text {}, 'lorem Lorem ipsum Nostrud eiusmod voluptate anim et Duis elit dolore aliquip eu pariatur nostrud ut in enim id Excepteur sed sit veniam nostrud anim nisi in adipisicing nulla aute dolore proident enim occaecat fugiat et anim nulla eiusmod est anim ex commodo sed ea in eiusmod Duis minim proident minim quis exercitation non laborum reprehenderit irure incididunt sint do dolore incididunt exercitation nulla laboris dolore reprehenderit sunt do adipisicing sunt consequat eu id Excepteur velit ut culpa laboris culpa occaecat ad anim enim sed ut reprehenderit reprehenderit dolore laborum in labore veniam sed id do aliquip veniam in veniam dolor ex anim fugiat id quis incididunt quis qui sit qui exercitation esse deserunt eiusmod laboris ex dolore culpa cillum in reprehenderit non mollit laboris eu occaecat sit labore enim aliqua quis sint cillum proident adipisicing et velit reprehenderit voluptate elit enim nulla aliqua culpa sint in ullamco ullamco et ullamco labore dolore Duis commodo eiusmod voluptate consequat enim mollit nulla sed sit officia sint consectetur qui laborum enim cillum enim dolore.'
            # Text {}, 'lorem Lorem ipsum Nostrud eiusmod voluptate anim et Duis elit dolore aliquip eu pariatur nostrud ut in enim id Excepteur sed sit veniam nostrud anim nisi in adipisicing nulla aute dolore proident enim occaecat fugiat et anim nulla eiusmod est anim ex commodo sed ea in eiusmod Duis minim proident minim quis exercitation non laborum reprehenderit irure incididunt sint do dolore incididunt exercitation nulla laboris dolore reprehenderit sunt do adipisicing sunt consequat eu id Excepteur velit ut culpa laboris culpa occaecat ad anim enim sed ut reprehenderit reprehenderit dolore laborum in labore veniam sed id do aliquip veniam in veniam dolor ex anim fugiat id quis incididunt quis qui sit qui exercitation esse deserunt eiusmod laboris ex dolore culpa cillum in reprehenderit non mollit laboris eu occaecat sit labore enim aliqua quis sint cillum proident adipisicing et velit reprehenderit voluptate elit enim nulla aliqua culpa sint in ullamco ullamco et ullamco labore dolore Duis commodo eiusmod voluptate consequat enim mollit nulla sed sit officia sint consectetur qui laborum enim cillum enim dolore.'
            # Text {}, 'lorem Lorem ipsum Nostrud eiusmod voluptate anim et Duis elit dolore aliquip eu pariatur nostrud ut in enim id Excepteur sed sit veniam nostrud anim nisi in adipisicing nulla aute dolore proident enim occaecat fugiat et anim nulla eiusmod est anim ex commodo sed ea in eiusmod Duis minim proident minim quis exercitation non laborum reprehenderit irure incididunt sint do dolore incididunt exercitation nulla laboris dolore reprehenderit sunt do adipisicing sunt consequat eu id Excepteur velit ut culpa laboris culpa occaecat ad anim enim sed ut reprehenderit reprehenderit dolore laborum in labore veniam sed id do aliquip veniam in veniam dolor ex anim fugiat id quis incididunt quis qui sit qui exercitation esse deserunt eiusmod laboris ex dolore culpa cillum in reprehenderit non mollit laboris eu occaecat sit labore enim aliqua quis sint cillum proident adipisicing et velit reprehenderit voluptate elit enim nulla aliqua culpa sint in ullamco ullamco et ullamco labore dolore Duis commodo eiusmod voluptate consequat enim mollit nulla sed sit officia sint consectetur qui laborum enim cillum enim dolore.'
            # Text {}, 'lorem Lorem ipsum Nostrud eiusmod voluptate anim et Duis elit dolore aliquip eu pariatur nostrud ut in enim id Excepteur sed sit veniam nostrud anim nisi in adipisicing nulla aute dolore proident enim occaecat fugiat et anim nulla eiusmod est anim ex commodo sed ea in eiusmod Duis minim proident minim quis exercitation non laborum reprehenderit irure incididunt sint do dolore incididunt exercitation nulla laboris dolore reprehenderit sunt do adipisicing sunt consequat eu id Excepteur velit ut culpa laboris culpa occaecat ad anim enim sed ut reprehenderit reprehenderit dolore laborum in labore veniam sed id do aliquip veniam in veniam dolor ex anim fugiat id quis incididunt quis qui sit qui exercitation esse deserunt eiusmod laboris ex dolore culpa cillum in reprehenderit non mollit laboris eu occaecat sit labore enim aliqua quis sint cillum proident adipisicing et velit reprehenderit voluptate elit enim nulla aliqua culpa sint in ullamco ullamco et ullamco labore dolore Duis commodo eiusmod voluptate consequat enim mollit nulla sed sit officia sint consectetur qui laborum enim cillum enim dolore.'
            # Text {}, 'lorem Lorem ipsum Nostrud eiusmod voluptate anim et Duis elit dolore aliquip eu pariatur nostrud ut in enim id Excepteur sed sit veniam nostrud anim nisi in adipisicing nulla aute dolore proident enim occaecat fugiat et anim nulla eiusmod est anim ex commodo sed ea in eiusmod Duis minim proident minim quis exercitation non laborum reprehenderit irure incididunt sint do dolore incididunt exercitation nulla laboris dolore reprehenderit sunt do adipisicing sunt consequat eu id Excepteur velit ut culpa laboris culpa occaecat ad anim enim sed ut reprehenderit reprehenderit dolore laborum in labore veniam sed id do aliquip veniam in veniam dolor ex anim fugiat id quis incididunt quis qui sit qui exercitation esse deserunt eiusmod laboris ex dolore culpa cillum in reprehenderit non mollit laboris eu occaecat sit labore enim aliqua quis sint cillum proident adipisicing et velit reprehenderit voluptate elit enim nulla aliqua culpa sint in ullamco ullamco et ullamco labore dolore Duis commodo eiusmod voluptate consequat enim mollit nulla sed sit officia sint consectetur qui laborum enim cillum enim dolore.'
            # Text {}, 'lorem Lorem ipsum Nostrud eiusmod voluptate anim et Duis elit dolore aliquip eu pariatur nostrud ut in enim id Excepteur sed sit veniam nostrud anim nisi in adipisicing nulla aute dolore proident enim occaecat fugiat et anim nulla eiusmod est anim ex commodo sed ea in eiusmod Duis minim proident minim quis exercitation non laborum reprehenderit irure incididunt sint do dolore incididunt exercitation nulla laboris dolore reprehenderit sunt do adipisicing sunt consequat eu id Excepteur velit ut culpa laboris culpa occaecat ad anim enim sed ut reprehenderit reprehenderit dolore laborum in labore veniam sed id do aliquip veniam in veniam dolor ex anim fugiat id quis incididunt quis qui sit qui exercitation esse deserunt eiusmod laboris ex dolore culpa cillum in reprehenderit non mollit laboris eu occaecat sit labore enim aliqua quis sint cillum proident adipisicing et velit reprehenderit voluptate elit enim nulla aliqua culpa sint in ullamco ullamco et ullamco labore dolore Duis commodo eiusmod voluptate consequat enim mollit nulla sed sit officia sint consectetur qui laborum enim cillum enim dolore.'

            Block {},
              Columns grow: 1, style:{outline:'1px solid purple'},
                Block style:{outline:'1px solid red'}, 'A'
                Block style:{outline:'1px solid red'}, 'B'
                Block style:{outline:'1px solid red'}, 'C'
                Block style:{outline:'1px solid red'}, 'D'
            Block {},
              Rows grow: 1, style:{outline:'1px solid purple'},
                Block style:{outline:'1px solid red'}, 'A'
                Block style:{outline:'1px solid red'}, 'B'
                Block style:{outline:'1px solid red'}, 'C'
                Block style:{outline:'1px solid red'}, 'D'

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
