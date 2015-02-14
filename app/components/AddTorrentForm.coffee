React     = require 'react'
component = require '../component'
torrentz  = require '../torrentz'
PromiseStateMachine = require './PromiseStateMachine'
ActionLink = require './ActionLink'
Table = require 'react-bootstrap/Table'

{div, span, form, input, button, table, thead, tbody, tr, th, td} = React.DOM

SEARCH_DELAY = 1000
module.exports = component 'AddTorrentForm',

  contextTypes:
    putio: React.PropTypes.any.isRequired

  getInitialState: ->
    value: ''
    searchTimeout: null
    searchResultsPromise: null

  onChange: (event) ->
    @setState value: event.target.value
    setTimeout @scheduleSearch

  valueIsBlank: ->
    @state.value.match(/^\s*$/)

  valueIsMagnetLink: ->
    @state.value.match(/^magnet:/)

  onSubmit: (event) ->
    event.preventDefault()
    # Not doing this allows you to search for the most popular torrents
    # return if @valueIsBlank()
    if @valueIsMagnetLink()
      @addTorrent(@state.value)
    else
      @performSeach()

  clear: ->
    clearTimeout(@state.searchTimeout)
    @setState
      value: ''
      searchTimeout: null
      searchResultsPromise: null

  addTorrent: (magnetLink) ->
    @context.putio.transfers.add magnetLink
    @clear()

  scheduleSearch: ->
    clearTimeout(@state.searchTimeout)
    if @valueIsBlank() || @valueIsMagnetLink()
      @setState
        searchResultsPromise: null
        searchTimeout: null
    else
      @setState
        searchResultsPromise: null
        searchTimeout: setTimeout(@performSeach, SEARCH_DELAY)

  performSeach: ->
    @setState searchResultsPromise: torrentz.search(@state.value)

  render: ->
    div
      className: 'AddTorrentForm'
      form
        onSubmit: @onSubmit
        @renderInput()
        @renderAddTorrentButton()

      @renderSearchResults()

  renderInput: ->
    input
      type: 'text'
      placeholder: 'search or paste magnet link'
      value: @state.value
      onChange: @onChange

  renderAddTorrentButton: ->
    if @valueIsMagnetLink()
      input
        type: 'submit'
        value: 'Add Torrent'


  renderSearchResults: ->
    if @state.searchResultsPromise
      SearchResults
        key: @state.value
        promise: @state.searchResultsPromise
        addTorrent: @addTorrent


SearchResults = component 'AddTorrentForm-SearchResults',

  propTypes:
    promise:    React.PropTypes.object.isRequired
    addTorrent: React.PropTypes.func  .isRequired

  render: ->
    div
      className: 'AddTorrentForm-SearchResults',
      PromiseStateMachine
        promise: @props.promise
        loading: -> div(null, 'Loading…')
        loaded: @renderSearchResults

  renderSearchResults: (results) ->
    results = results.map (result) =>
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
      if results.length == 0
        tr(null, td(colSpan: 6, 'No results found :/'))
      else
        results



SearchResult = component 'AddTorrentForm-SearchResult',

  propTypes:
    id:         React.PropTypes.string.isRequired
    title:      React.PropTypes.string.isRequired
    date:       React.PropTypes.string.isRequired
    size:       React.PropTypes.string.isRequired
    rating:     React.PropTypes.any
    leachers:   React.PropTypes.any
    seeders:    React.PropTypes.any
    addTorrent: React.PropTypes.func.isRequired

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

  addTorrent: ->
    torrentz.getMagnetLink(@props.id).then (magnetLink) =>
      @props.addTorrent(magnetLink)

