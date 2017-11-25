# Registry

    { EventEmitter } = require 'events'

    class Registry extends EventEmitter

      constructor: ->

        super()

        @resources = {}

      isRegistered: (resource) -> @resources[resource.identifier]?.includes? resource

      register: (resource) ->

        return resource if @isRegistered resource

        { identifier } = resource

        unless resources = @resources[identifier]

          resources = @resources[identifier] = []

          @emit 'init', resource, @

        @emit 'register', resource, @

        resources.push resource

        () => @unregister resource

      unregister: (resource) ->

        return resource unless @isRegistered resource

        { identifier } = resource

        resources = @resources[identifier]

        @emit 'unregister', resource, @

        resources = @resources[identifier].filter (r) -> r isnt resource

        if resources.length is 0

          delete @resources[identifier]

          @emit 'release', resource, @

        else @resources[identifier] = resources

    module.exports = Registry