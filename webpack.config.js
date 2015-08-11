var Webpack = require('webpack');
var path = require('path');
var nodeModulesPath = path.resolve(__dirname, 'node_modules');
var assetsPath = path.resolve(__dirname, 'public', 'assets');
var clientPath = path.resolve(__dirname, 'client.js');

module.exports = {
  // Makes sure errors in console map to the correct file
  // and line number
  devtool: 'eval',
  entry: [
    clientPath
  ],
  output: {
    path: assetsPath,
    filename: 'client.js',
    publicPath: '/assets/'
  },
  module: {

    loaders: [

      // Let us also add the style-loader and css-loader, which you can
      // expand with less-loader etc.
      {
        test: /\.css$/,
        loader: 'style!css'
      }

    ]
  }
};