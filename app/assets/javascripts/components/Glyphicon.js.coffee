component 'Glyphicon',

  propTypes:
    glyph: React.PropTypes.string.isRequired

  render: ->
    props = Object.assign({}, @props)
    props.className ||= ''
    props.className += " glyphicon glyphicon-#{props.glyph}"
    props.glyph = undefined
    DOM.span(props, @props.children)


# var React = require('react');
# var joinClasses = require('./utils/joinClasses');
# var classSet = require('./utils/classSet');
# var BootstrapMixin = require('./BootstrapMixin');
# var constants = require('./constants');

# var Glyphicon = React.createClass({displayName: "Glyphicon",
#   mixins: [BootstrapMixin],

#   propTypes: {
#     glyph: React.PropTypes.oneOf(constants.GLYPHS).isRequired
#   },

#   getDefaultProps: function () {
#     return {
#       bsClass: 'glyphicon'
#     };
#   },

#   render: function () {
#     var classes = this.getBsClassSet();

#     classes['glyphicon-' + this.props.glyph] = true;

#     return (
#       React.createElement("span", React.__spread({},  this.props, {className: joinClasses(this.props.className, classSet(classes))}), 
#         this.props.children
#       )
#     );
#   }
# });

# module.exports = Glyphicon;