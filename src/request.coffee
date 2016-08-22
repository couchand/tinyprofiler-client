# request wrapper

pretty = require 'pretty-hrtime'

class Profile
  constructor: (@profile, @baseline=0) ->

  getName: ->
    @profile.name or ''

  getDetails: ->
    @profile.details

  # TODO: currently misleading - is relative
  getStart: ->
    return unless @profile.start
    pretty @profile.start

  getLength: ->
    return unless @profile.length
    pretty @profile.length

  getSteps: ->
    return [] unless @profile.steps
    (new Profile step for step in @profile.steps)

class Request extends Profile
  constructor: ->
    super

  getId: ->
    @profile.id

  getStart: ->
    new Date @profile.start

  @compare: (a, b) ->
    switch on
      when a.profile.start < b.profile.start then -1
      when b.profile.start < a.profile.start then 1
      else 0

module.exports = Request
