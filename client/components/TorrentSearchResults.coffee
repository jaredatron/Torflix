component      = require 'reactatron/component'
Box          = require 'reactatron/Box'
Block          = require 'reactatron/Block'
RemainingSpace = require 'reactatron/RemainingSpace'
withStyle      = require 'reactatron/withStyle'
{span}         = require 'reactatron/DOM'

Link = require './Link'

module.exports = component 'TorrentSearchResults',

  propTypes:
    query: component.PropTypes.string

  dataBindings: (props) ->
    search: "search/#{props.query}"

  requestSearch: (query) ->
    @app.pub('search for torrents', query) unless @state.search

  componentDidMount: ->
    @requestSearch(@props.query)

  componentWillReceiveProps: (nextProps) ->
    if nextProps.query != @props.query
      @requestSearch(nextProps.query)


  render: ->
    search = @state.search
    if search && search.results
      return Rows {}, search.results.map (result, index) ->
        Result(key:index, result: result)

    Block
      grow: 1
      style:
        alignItems: 'center'
        justifyContent: 'center'
        flexWrap: 'nowrap'
        fontSize: '150%'
        dontWeight: 'bold'
      Block {}, "searching for #{@props.query}..."




Result = component 'Result',

  propTypes:
    result: component.PropTypes.object.isRequired

  addTransferForSearchResult: (result) ->
    @app.pub "add search result", result
    @app.setLocation '/transfers'

  render: ->
    result = @props.result

    ResultRow {},
      Title result: result, onClick: @addTransferForSearchResult.bind(null, result)
      RemainingSpace {}
      Column width: '40px', Rating(result: result)
      Column width: '80px', result.date
      Column width: '40px', result.seeders
      Column width: '40px', result.leachers
      Column width: '60px', result.size

Column = component (props) ->
  props.extendStyle
    minWidth:  props.width
    flexBasis: props.width
    textAlign: 'right'
  props.style.marginLeft ||= '0.5em'
  delete props.width
  Box(props)

ResultRow = Columns.withStyle 'ResultRow',
  minHeight: '24px'
  whiteSpace: 'nowrap'
  padding: '0.25em 0.5em'
  borderBottom: '1px solid #DFEBFF'
  alignItems: 'center'
  lineHeight: '1.4'
  ':hover':
    backgroundColor: '#DFEBFF'
  ':active':
    backgroundColor: '#DFEBFF'



Title = (props) ->
  Link
    onClick: props.onClick
    style:
      flexShrink: 1
      overflow:'hidden'
    props.result.title

Rating = (props) ->
  rating = Number(props.result.rating)
  return null if rating == 0
  Badge({}, rating)

Badge = span.withStyle 'Badge',
  display: 'inline'
  padding: '0 0.5em'
  backgroundColor: '#DFEBFF'
  borderRadius: '8px'
  fontSize: '90%'
  fontWeight: 'bold'


Age = (props) ->
  Block style: { minWidth: '80px', flexBasis: '80px', marginLeft: '0.5em' }, props.result.date
