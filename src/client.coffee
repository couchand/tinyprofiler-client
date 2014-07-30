# tinyprofiler client

xtend = require 'xtend'

fetcher = require './fetch'
patcher = require './xhr-patch'
Request = require './request'

defaults =
  monkeyPatch: yes

isTinyProfiler = (profiler) ->
  profiler?.constructor?.name is 'TinyProfiler'

class TinyProfilerClient
  constructor: ->
    if isTinyProfiler arguments[0]
      profiler = arguments[0]
      opts = arguments[1]
    else
      opts = arguments[0]

    options = xtend {}, defaults, opts

    @_requests = []

    @_fetch = fetcher opts

    if options.monkeyPatch
      unless patcher opts, @_handleRequest
        console.error "TinyProfiler patching error"

    if profiler
      profiler.on 'complete', (req) =>
        # clear request from the tinyprofiler cache
        profile = profiler.getById req.getId()
        @_push profile.toJSON()

  _handleRequest: (err, ids) => # allow handler passing
    return console.error "TinyProfiler patch error: #{err}" if err
    @fetch id for id in ids

  _push: (req) ->
    @_requests.push new Request req

  fetch: (id) ->
    @_fetch id, (err, profile) =>
      return console.error "TinyProfiler fetch error: #{err}" if err
      @_push profile

  getById: (id) ->
    for r in @_requests when id is r.id
      return r
    null

  getRequests: ->
    @_requests.slice()

module.exports = TinyProfilerClient
