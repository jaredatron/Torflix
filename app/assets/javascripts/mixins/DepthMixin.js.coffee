@DepthMixin =

  contextTypes:
    depth: React.PropTypes.number

  childContextTypes:
    depth: React.PropTypes.number

  getChildContext: ->
    depth: @depth() + 1

  depth: ->
    @context.depth || 0

  depthStyle: ->
    { paddingLeft: "#{@depth()-1}em" }
