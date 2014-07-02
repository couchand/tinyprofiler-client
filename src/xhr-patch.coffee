# monkey patch the window xhr object
#   borrowed with love from miniprofiler

DONE = 4

xtend = require 'xtend'

defaults =
  headerName: "X-TinyProfiler-Ids"

module.exports = patch = (opts, cb) ->
  return no unless window?.XMLHttpRequest?

  options = xtend {}, defaults, opts

  send = XMLHttpRequest.prototype.send

  XMLHttpRequest.prototype.send = ->
    handle = @onreadystatechange

    @onreadystatechange = ->
      if @readyState is DONE
        json = @getResponseHeader options.headerName
        if json
          try
            ids = JSON.parse json
          catch e
            cb e
          cb null, ids if ids

      handle.apply this, arguments

    send.apply this, arguments

  yes
