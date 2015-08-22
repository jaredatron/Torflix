component = require 'reactatron/component'

module.exports = component 'TransfersStatusIcon',

  propTypes:
    status: component.PropTypes.string.isRequired

  render: ->
    glyph = switch @props.status
      when 'IN_QUEUE'    then 'pause'
      when 'DOWNLOADING' then 'download-alt'
      when 'COMPLETING'  then 'wrench'
      when 'SEEDING'     then 'open'
      when 'COMPLETED'   then 'ok'
      when 'ERROR'       then 'question-sign'
      else
        console.log('UNKNOWN transfer status:', @props.transfer)
        'question-sign'

    DOM.Glyphicon glyph: glyph, className: 'TransfersList-Transfer-statusIcon'
