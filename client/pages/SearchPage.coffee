slice = require 'shouldhave/slice'
component = require 'reactatron/component'
Rows = require 'reactatron/Rows'
Layout = require '../components/Layout'
TorrentSeachForm = require '../components/TorrentSeachForm'
TorrentSearchResults = require '../components/TorrentSearchResults'

module.exports = component 'SearchPage',

  componentDidMount: ->
    searchInput = @searchInput()
    searchInput.select()
    searchInput.focus()



  searchInput: ->
    @refs.SeachForm.getDOMNode().querySelector('input')

  getFocusableElements: ->
    slice(@getDOMNode().querySelectorAll('input[type=text],a[href]'))

  onKeyDown: (event) ->
    searchInput = @searchInput()

    switch event.keyCode
      when 38 # up
        event.preventDefault()
        if event.target != searchInput
          elements = @getFocusableElements()
          index = elements.indexOf(event.target) - 1
          index = 0 if index < 0
          elements[index]?.focus()
      when 40 # down
        event.preventDefault()
        elements = @getFocusableElements()
        index = elements.indexOf(event.target) + 1
        index = 0 if index >= elements.size
        elements[index]?.focus()
      when 191 # /
        event.preventDefault()
        if event.target != searchInput
          searchInput.select()
          searchInput.focus()


  render: ->
    query = @props.query

    if query?
      results = TorrentSearchResults query: query

    Layout null,
      Rows
        style: {width: '100%', overflowY: 'scroll'}
        onKeyDown: @onKeyDown
        TorrentSeachForm
          ref: 'SeachForm'
          style: margin: '1em'
          defaultValue: query
        results




