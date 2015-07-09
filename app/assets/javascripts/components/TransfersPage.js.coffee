component 'TransfersPage',

  contextTypes:
    putio: React.PropTypes.object.isRequired
    params: React.PropTypes.object.isRequired
  
  render: ->
    DOM.TransfersList()