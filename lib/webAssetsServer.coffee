Webpack = require('webpack')
WebpackDevServer = require('webpack-dev-server')
webpackConfig = require('../webpack.config.js')

module.exports =
  port: 3024

  start: ->
    # First we fire up Webpack an pass in the configuration we
    # created
    bundleStart = null
    compiler = Webpack(webpackConfig)
    # We give notice in the terminal when it starts bundling and
    # set the time it started
    compiler.plugin 'compile', ->
      console.log 'Bundling...'
      bundleStart = Date.now()
      return
    # We also give notice when it is done compiling, including the
    # time it took. Nice to have
    compiler.plugin 'done', ->
      console.log 'Bundled in ' + Date.now() - bundleStart + 'ms!'
      return
    bundler = new WebpackDevServer(compiler,
      publicPath: webpackConfig.output.publicPath
      quiet: false
      noInfo: true
      stats: colors: true)
    # We fire up the development server and give notice in the terminal
    # that we are starting the initial bundle
    bundler.listen @port, 'localhost', ->
      console.log 'Bundling project, please wait...'
      return
    return

