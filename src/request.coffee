# request wrapper

pretty = require 'pretty-hrtime'

class Profile
  constructor: (@profile, @baseline=0) ->

  getName: ->
    @profile.name or ''

  getDetails: ->
    @profile.details

  # TODO: currently wrong
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

module.exports = Request
