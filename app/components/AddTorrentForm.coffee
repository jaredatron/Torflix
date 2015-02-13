React     = require 'react'
component = require '../component'
torrentz  = require '../torrentz'
PromiseStateMachine = require './PromiseStateMachine'
ActionLink = require './ActionLink'
Table = require 'react-bootstrap/Table'

{div, form, input, button, table, thead, tbody, tr, th, td} = React.DOM

module.exports = component 'AddTorrentForm',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    value: ''

  onChange: (event) ->
    @setState value: event.target.value

  onSubmit: (event) ->
    event.preventDefault()
    @context.putio.transfers.add @state.value
    @setState value: ''

  buttonValue: ->
    'Add'

  buttonDisabled: ->
    @state.value.length == 0

  clear: ->
    @setState value: ''

  addTorrent: (torrentId) ->
    debugger
    @clear()

  render: ->
    div
      className: 'AddTorrentForm'
      form
        onSubmit: @onSubmit
        input
          type: 'text'
          placeholder: 'search or paste magnet link'
          value: @state.value
          onChange: @onChange
        input
          type: 'submit'
          value: @buttonValue()
          disabled: @buttonDisabled()

      SearchResults
        query: @state.value
        addTorrent: @addTorrent



 SearchResults = component 'AddTorrentForm-SearchResults',

  propTypes:
    query:      React.PropTypes.string.isRequired
    addTorrent: React.PropTypes.func  .isRequired

  getInitialState: ->
    promise: torrentz.search(@props.query)

  componentWillReceiveProps: (props) ->
    if @props.query != props.query
      @setState promise: torrentz.search(props.query)


  render: ->
    if @props.query.length > 0
      results = PromiseStateMachine
        promise: @state.promise
        loaded: @renderSearchResults

    div className: 'AddTorrentForm-SearchResults', results

  renderSearchResults: (results) ->
    Table
      responsive: true
      striped: true
      bordered: true
      condensed: true
      hover: true
      thead null,
        tr null,
          th null, 'Title'
          th null, 'Rating'
          th null, 'Age'
          th null, 'Size'
          th null, 'Seeders'
          th null, 'Leachers'
      tbody null,
        results.map (result) =>
          SearchResult
            key:        result.id,
            id:         result.id,
            title:      result.title,
            date:       result.date,
            leachers:   result.leachers,
            rating:     result.rating,
            seeders:    result.seeders,
            size:       result.size,
            addTorrent: @props.addTorrent


SearchResult = component 'AddTorrentForm-SearchResult',

  propTypes:
    id:         React.PropTypes.string.isRequired # "bf937884bdb76d2b9b16b73e95dad5541db1f4ec"
    date:       React.PropTypes.string.isRequired # "11 hours"
    leachers:   React.PropTypes.number.isRequired #  null
    rating:     React.PropTypes.number.isRequired #  1
    seeders:    React.PropTypes.number.isRequired #  null
    size:       React.PropTypes.string.isRequired # "159 MB"
    title:      React.PropTypes.string.isRequired # "Drake If You're Reading This It's Too Late 2015 album MP3 320 kpbs CTRC"
    addTorrent: React.PropTypes.func  .isRequired

  render: ->
    tr null,
      td null,
        ActionLink
          onClick: @addTorrent
          @props.title
      td null,
        @props.rating
      td null,
        @props.date
      td null,
        @props.size
      td null,
        @props.seeders
      td null,
        @props.leachers

    # ActionLink
    #   className: 'AddTorrentForm-SearchResult flex-row',
    #   onClick: @addTorrent
    #   div(className: 'AddTorrentForm-SearchResult-title',  @props.title)
    #   div(className: 'flex-spacer')
    #   div(className: 'AddTorrentForm-SearchResult-rating', @props.rating)
    #   div(className: 'AddTorrentForm-SearchResult-size',   @props.size)

  addTorrent: ->
    @props.addTorrent(@props.id)

