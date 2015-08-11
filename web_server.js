require('./environment');
var express = require('express');
var app = express();
var asset_path = require('./asset_path')

if ('development' === process.env.NODE_ENV){
  var httpProxy = require('http-proxy');
  var proxy = httpProxy.createProxyServer();
  var web_assets_server = require('./web_assets_server')
  web_assets_server.start()

  app.get('/assets/*', function (req, res) {
    proxy.web(req, res, {
      target: 'http://localhost:'+web_assets_server.port
    });
  });
}

app.set('port', (process.env.PORT || 3000));

app.use(express.static(__dirname + '/public'));

// views is directory for all template files
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');

app.get('/*', function(request, response) {
  fs.readFile('/etc/passwd', function (err, html) {
    if (err) throw err;
    reponse.send(html);
  });
});

app.listen(app.get('port'), function() {
  if (app.get('port') === 3000){
    console.log('Node app is running at http://torflix.dev');
  }
});
