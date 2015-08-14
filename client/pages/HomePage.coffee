component = require 'reactatron/component'
{div, h1} = require 'reactatron/DOM'
Link = require '../components/Link'

module.exports = component 'HomePage',
  render: ->
    div
      className: 'HomePage'
      h1(null, 'Welcome')
      div null,
        Link href: '/transfers', 'transfers'


      div null, '----'

      div null,
        Link href: 'http://google.com', 'Google'
      div null,
        Link href: '/home', 'Home'
      div null,
        Link href: '', 'empty'
      div null,
        Link href: 'home', 'relative home'
      div null,
        Link href: '/?a=b', 'home with params'
      div null,
        Link href: '?a=b', 'empty with params'
      div null,
        Link href: '/transfers?a=b', 'transfers with params'
