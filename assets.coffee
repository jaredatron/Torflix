fs = require 'fs'
path = require 'path'
browserify = require 'browserify'
sass = require 'node-sass'
React = require 'react'

APP_ROOT = __dirname

module.exports = assets = {}

assets.compile_javascript = (name, callback) ->
  try
    asset = browserify
      basedir: APP_ROOT
      debug: true
      watch: true
      transforms: ['coffeeify', 'envify']
      extensions: [".cjsx", ".coffee", ".js", ".json"]
      # paths:      ['./', './node_modules']

    asset.add "./app/#{name}"
    bundle = asset.bundle()

    javascipt = ''

    bundle.on 'data', (data) ->
      javascipt = javascipt + data;

    bundle.on 'end', ->
      callback(null, javascipt)

    bundle.on 'error', (error) ->
      callback(error, null)

  catch error
    callback(error, null)

assets.compile_stylesheet = (name, callback) ->
  sass_path = path.join(APP_ROOT, "style/#{name}.sass")
  css_path = path.join(APP_ROOT, "public/#{name}.css")

  sass.render
    file: sass_path,

    includePaths: [
      path.join(APP_ROOT, 'style')
      path.join(APP_ROOT, 'vendor/style')
    ]
    success: (results) ->
      callback(null, results.css)
    error: (error) ->
      callback(error)


assets.compile_html = (callback) ->
  {html, head, title, link, body, script} = React.DOM
  try
    asset = React.renderToStaticMarkup(
      html(null,
        head(null,
          title(null, 'put.io')
          link(rel: 'stylesheet', href: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css', type: 'text/css')
          link(rel: 'stylesheet', href: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css', type: 'text/css')
          link(rel: 'stylesheet', href: '/app.css', type: 'text/css')
        )
        body(null,
          # script(type: 'text/javascript', src: '//put.io/web/jwplayer/jwplayer.js')
          script(type: 'text/javascript', src: '/app.js')
        )
      )
    )
    callback null, asset

  catch error
    callback error


write_to = (path) ->
  (error, value) ->
    throw error if error
    if value.pipe?
      value.pipe fs.createWriteStream(path)
    else
      fs.writeFile path, value, (error) ->
        throw error if error


assets.precompile = (callback) ->
  assets.compile_stylesheet 'app', write_to('./public/app.css')
  assets.compile_javascript 'client', write_to('./public/app.js')
  assets.compile_html write_to('./public/app.html')
