component 'Modal',

  propTypes:
    onRequestHide: React.PropTypes.func.isRequired

  render: ->
    {div} = DOM
    div 
      className: 'modal fade in',
      div 
        className: 'modal-dialog',
        @props.children

