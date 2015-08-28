Stylesheet = require 'reactatron/Stylesheet'

module.exports = stylesheet = new Stylesheet(document)

stylesheet.appendRule """
body {
  color: purple;
}
"""
