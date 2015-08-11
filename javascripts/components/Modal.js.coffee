component 'Modal',

  propTypes:
    onRequestHide: React.PropTypes.func.isRequired

  containerNode: ->
    document.body

  componentDidMount: ->
    node = @getDOMNode()
    node.classList.add('in')
    node.style.display = 'block'
    @containerNode().classList.add('modal-open')

  componentWillUnmount: ->
    @containerNode().classList.remove('modal-open')



  render: ->
    {div} = DOM
    div
      className: 'modal fade',
      div
        className: 'modal-dialog',
        div
          className: 'modal-content',
            @props.children
