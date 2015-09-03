component = require 'reactatron/component'
Layer = require 'reactatron/Layer'
Rows = require 'reactatron/Rows'
Block = require 'reactatron/Block'
LoginButton = require '../components/LoginButton'

styles = require '../styles'

module.exports = component 'LoginPage',

  addPutioAccessToken: ->
    @app.logout()

  render: ->
    BlueLayer {},
      LogoText {}, 'Torflix'
      LoginButton {}


BlueLayer = Layer.withStyle 'BlueLayer',
  backgroundColor: styles.colors.darkBlue
  flexGrow: 1
  alignItems: 'center'
  justifyContent: 'center'
  flexWrap: 'nowrap'
  flexDirection: 'column'

LogoText = Block.withStyle 'LogoText',
  fontSize: '200%'
  color: styles.colors.orange
