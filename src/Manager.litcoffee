# Manager

    Registry = require './Registry'

    class Manager

      constructor: (@registry) ->

        @registry ?= new Registry

        @registry.on 'init', (resource) => @init? resource

        @registry.on 'register', (resource) => @register? resource

        @registry.on 'unregister', (resource) => @unregister? resource

        @registry.on 'release', (resource) => @release? resource

      manage: (resources...) ->

        resources.forEach (resource) => @registry.register resource

        @

      unmanage: (resources...) ->

        resources.forEach (resource) => @registry.unregister resource

        @

    module.exports = Manager