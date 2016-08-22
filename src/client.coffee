# tinyprofiler client

xtend = require 'xtend'
{EventEmitter2} = require 'eventemitter2'

fetcher = require './fetch'
patcher = require './xhr-patch'
Request = require './request'

defaults =
  maxProfiles: 20
  monkeyPatch: yes

isTinyProfiler = (profiler) ->
  profiler?.constructor?.name is 'TinyProfiler'

class TinyProfilerClient extends EventEmitter2
  constructor: ->
    if isTinyProfiler arguments[0]
      profiler = arguments[0]
      opts = arguments[1]
    else
      opts = arguments[0]

    @options = options = xtend {}, defaults, opts

    @_requests = []
    @_fetches = []

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
    toFetch = (id for id in ids when id not in @_fetches)
    @_fetches = @_fetches.concat toFetch
    @fetch id for id in toFetch

  _push: (req) ->
    count = @_requests.push new Request req
    @_requests.sort Request.compare
    max = @options.maxProfiles
    unless count < max
      @_requests = @_requests.slice count - max + 1
    @emit 'profile', req

  fetch: (id) ->
    @_fetch id, (err, profile) =>
      return console.error "TinyProfiler fetch error: #{err}" if err
      @_fetches = (fetch for fetch in @_fetches when fetch isnt id)
      @_push profile

  getById: (id) ->
    for r in @_requests when id is r.getId()
      return r
    null

  remove: (id) ->
    @_requests = (r for r in @_requests when id isnt r.getId())

  getRequests: ->
    @_requests.slice()

module.exports = TinyProfilerClient
