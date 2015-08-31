require('./environment')

var path = require('path');

var asset_path;

if ('development' === process.env.NODE_ENV){
  asset_path = function(asset){
    return 'http://localhost:3024'+path.join('/webpack-dev-server/', asset);
  };
}else{
  asset_path = function(asset){
    return path.join('/',asset);
  };
}

module.exports = asset_path
