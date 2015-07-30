# Torflix

## Put.io

Toflix is an alternate interface for [put.io](http://put.io) so you'll need an account with them

## Chrome Extension

The [Torflix-chrome-extension](https://github.com/deadlyicon/Torflix-chrome-extension) allows torflix.jaredatron.com to
make cross-domain AJAX calls so we can scape the web for you :D

## Development

#### Setup

##### Pow

I run my development app using pow at http://torflix.dev

##### put.io Api Keys

Register your development app [here](https://put.io/v2/oauth2/register)

I've set mine up like this

```
Application Name:     Torflix Development
Description:          Torflix development
Application Web Site: torflix.dev
Callback url:         http://torflix.dev/
```

##### thetvdb.com API Keys

Register for a account [here](http://thetvdb.com/?tab=register)

Register for a new api key [here](http://thetvdb.com/?tab=apiregister)

##### .env

You'll need a `.env` file that looks like this

```sh
RAILS_ENV=development
PUT_IO_APPLICATION_SECRET=
PUT_IO_CLIENT_ID=
PUT_IO_OAUTH_TOKEN=
PUT_IO_REDIRECT_URI=http://torflix.dev/
THETVDB_API_KEY=
```
