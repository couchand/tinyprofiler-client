# fetch a profile from the server

request = require 'superagent'
xtend = require 'xtend'

defaults =
  path: "tp"

module.exports = fetcher = (opts) ->
  options = xtend {}, defaults, opts

  fetch = (id, cb) ->
    request "/#{options.path}/#{id}", (err, res) ->
      return cb err if err
      return cb res.text if res.error
      return cb res.text unless res.body

      cb null, res.body
