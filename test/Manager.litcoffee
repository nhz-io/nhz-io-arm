# Manager test

    { EventEmitter } = require 'events'
    should = (require 'chai').should()

    Registry = require '../src/Registry'
    Manager = require '../src/Manager'

    describe 'Manager', ->

      it 'should be subclass of EventEmitter', ->
        expect(EventEmitter.prototype.isPrototypeOf Manager.prototype).to.be.true

      describe '#constructor()', ->

        it 'should initialize registry', ->

          manager = new Manager

          expect((new Manager).registry).to.be.an.instanceOf Registry

        it 'should use supplied registry', ->

          registry = new Registry

          expect((new Manager registry).registry).to.be.equal registry

        it 'should bind to registry.init event', (done) ->

          new Manager {
            on: (event, cb) ->
              if event is 'init' and typeof cb is 'function' then done()
          }

        it 'should bind to registry.register event', (done) ->

          new Manager {
            on: (event, cb) ->
              if event is 'register' and typeof cb is 'function' then done()
          }

        it 'should bind to registry.unregister event', (done) ->

          new Manager {
            on: (event, cb) ->
              if event is 'unregister' and typeof cb is 'function' then done()
          }

        it 'should bind to registry.release event', (done) ->

          new Manager {
            on: (event, cb) ->
              if event is 'release' and typeof cb is 'function' then done()
          }

      describe '#manage()', ->

        it 'should call Registry.register for every resource', ->

          results = []

          manager = new Manager {
            on: ->
            register: (resource) -> results.push resource
          }

          resource1 = { identifier: 'ident' }
          resource2 = { identifier: 'ident' }

          manager.manage resource1, resource2

          expect(results).to.be.deep.equal [resource1, resource2]

        it 'should call manager.init()', (done) ->

          resource = { identifier: 'ident' }

          manager = new Manager

          manager.init = (res) -> if res is resource then done()

          manager.manage resource

        it 'should call manager.register()', (done) ->

          resource = { identifier: 'ident' }

          manager = new Manager

          manager.register = (res) -> if res is resource then done()

          manager.manage resource

      describe '#unmanage()', ->

        it 'should call Registry.unregister for every resource', ->

          results = []

          manager = new Manager {
            on: ->
            unregister: (resource) -> results.push resource
          }

          resource1 = { identifier: 'ident' }
          resource2 = { identifier: 'ident' }

          manager.unmanage resource1, resource2

          expect(results).to.be.deep.equal [resource1, resource2]

        it 'should call manager.unregister()', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.register resource

          manager = new Manager registry

          manager.unregister = (res) -> if res is resource then done()

          manager.unmanage resource

        it 'should call manager.unregister()', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.register resource

          manager = new Manager registry

          manager.release = (res) -> if res is resource then done()

          manager.unmanage resource
