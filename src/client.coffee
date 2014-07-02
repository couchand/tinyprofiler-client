# tinyprofiler client

xtend = require 'xtend'

fetcher = require './fetch'
patcher = require './xhr-patch'
Request = require './request'

defaults =
  monkeyPatch: yes

class TinyProfilerClient
  constructor: (opts) ->
    options = xtend {}, defaults, opts

    @_requests = []

    @_fetch = fetcher opts
    unless patcher opts, @_handleRequest
      console.error "TinyProfiler patching error"

  _handleRequest: (err, ids) => # allow handler passing
    return console.error "TinyProfiler patch error: #{err}" if err
    @fetch id for id in ids

  fetch: (id) ->
    @_fetch id, (err, profile) =>
      return console.error "TinyProfiler fetch error: #{err}" if err
      @_requests.push profile

  getById: (id) ->
    for r in @_requests when id is r.id
      return new Request r
    null

  getRequests: ->
    (new Request req for req in @_requests)

module.exports = TinyProfilerClient
