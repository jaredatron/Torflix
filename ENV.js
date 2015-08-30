var fs = require('fs')
var dotenv = require('dotenv')
module.exports = dotenv.parse(fs.readFileSync('.env', { encoding: 'utf8' }))
