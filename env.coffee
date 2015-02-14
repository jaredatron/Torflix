NODE_ENV = process.env.NODE_ENV || 'development'

if true # NODE_ENV == 'development'
  # load .env file
  require('node-env-file')(__dirname + '/.env');

verify_env_variable = (name) ->
  return if process.env[name]?
  throw new Error("expected ENV variable #{name} to be present")

verify_env_variable 'PUT_IO_APPLICATION_SECRET'
verify_env_variable 'PUT_IO_CLIENT_ID'
verify_env_variable 'PUT_IO_OAUTH_TOKEN'
verify_env_variable 'PUT_IO_REDIRECT_URI'

module.exports = NODE_ENV
