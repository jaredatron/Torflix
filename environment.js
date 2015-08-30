var ENV = require('./ENV')

Object.keys(ENV).forEach(function (key) {
  process.env[key] = process.env[key] || ENV[key];
});
