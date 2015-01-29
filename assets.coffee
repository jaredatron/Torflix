fs = require 'fs'
path = require 'path'
browserify = require 'browserify'
sass = require 'node-sass'

APP_ROOT = __dirname

module.exports = assets = {}

assets.javascript = (name, callback) ->
  try
    asset = browserify
      basedir: APP_ROOT
      debug: true
      watch: true
      transforms: ['coffeeify', 'envify']
      extensions: [".cjsx", ".coffee", ".js", ".json"]

    asset.add "./app/#{name}"

    callback(null, asset.bundle())
  catch error
    callback(error)

assets.stylesheet = (name, callback) ->
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
