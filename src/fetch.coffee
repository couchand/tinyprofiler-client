# fetch a profile from the server

xtend = require 'xtend'

defaults =
  path: "tp"

module.exports = fetcher = (opts) ->
  options = xtend {}, defaults, opts

  unless window.fetch
    throw new Error "No fetch global available, too lazy to fallback to XHR."

  fetch = (id, cb) ->
    window.fetch "/#{options.path}/#{id}"

      .then (res) ->
        return cb res.statusText unless res.ok
        res.json().then (json) -> cb null, json

      .catch (err) -> cb err
