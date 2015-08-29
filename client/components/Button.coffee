Button = require 'reactatron/Button'

module.exports = Button.withStyle 'Button',
  alignSelf: 'center'
  outline: 'none'
  display: 'inlineBlock'
  padding: '6px 12px'
  marginBottom: '0'
  fontSize: '14px'
  fontWeight: '400'
  lineHeight: '1.42857143'
  textAlign: 'center'
  whiteSpace: 'nowrap'
  verticalAlign: 'middle'
  MsTouchAction: 'manipulation'
  touchAction: 'manipulation'
  cursor: 'pointer'
  WebkitUserSelect: 'none'
  MozUserSelect: 'none'
  MsUserSelect: 'none'
  userSelect: 'none'
  backgroundImage: 'none'
  border: '1px solid transparent'
  borderRadius: '4px'

  color: '#333'
  backgroundColor: '#fff'
  borderColor: '#ccc'


  ':hover':
    color: '#333'
    backgroundColor: '#e6e6e6'
    borderColor: '#adadad'

  # ':active': ???
  ':mousedown':
    zIndex: 2
    boxShadow: '0px 0px 5px 7px rgba(0,85,255,0.5)'

  ':focus':
    zIndex: 2
    boxShadow: '0px 0px 2px 3px rgba(0,85,255,0.5)'
