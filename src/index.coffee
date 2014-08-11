# tinyprofiler client

TinyProfilerClient = require './client'

module.exports = (client, opts) ->
  new TinyProfilerClient client, opts
