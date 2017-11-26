# Resource

    { EventEmitter } = require 'events'

    class Resource extends EventEmitter
      constructor: (identifier) ->
        throw TypeError 'Missing identifier' unless identifier

        super()

        @identifier = identifier

    module.exports = Resource