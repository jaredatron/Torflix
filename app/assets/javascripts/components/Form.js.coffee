component 'Form',
  
  render: ->
    DOM.form(@props,
      DOM.input(type: 'submit', style:{display:'none'})
      @props.children
    )