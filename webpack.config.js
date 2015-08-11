var path = require('path');

module.exports = {
  entry: "./client.js",
  output: {
    path: path.join(__dirname, 'public'),
    filename: "client.js"
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css" }
    ]
  }
};