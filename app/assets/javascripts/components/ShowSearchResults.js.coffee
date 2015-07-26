component 'ShowSearchResults',

  propTypes:
    query: React.PropTypes.string.isRequired

  render: ->
    DOM.SearchResults
      key: "query-#{@props.query}"
      promise: Show.search(@props.query)
      renderResult: @renderResult

  renderResult: (show) ->
    {div, p, LinkToShow} = DOM

    href = Location.for("/shows/#{show.id}")
    LinkToShow
      show: show,
      key: show.id
      p(className: 'link', show.name)
      p(className: 'small', show.description)
