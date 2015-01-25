# load .env file
require('node-env-file')(__dirname + '/.env');
module.exports = process.env
