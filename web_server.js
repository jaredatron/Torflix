require('./environment');
var express = require('express');
var app = express();
var asset_path = require('./asset_path')

app.set('port', (process.env.PORT || 3000));

app.use(express.static(__dirname + '/public'));

// views is directory for all template files
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');

app.get('/', function(request, response) {
  response.locals.asset_path = asset_path
  response.render('index');
});

app.listen(app.get('port'), function() {
  if (app.get('port') === 3000){
    console.log('Node app is running at http://torflix.dev');
  }
});
