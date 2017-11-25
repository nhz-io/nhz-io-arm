# Registry test

    { EventEmitter } = require 'events'

    Registry = require '../src/Registry'

    describe 'Registry', ->

      it 'should be subclass of EventEmitter', ->
        expect(EventEmitter.prototype.isPrototypeOf Registry.prototype).to.be.true

      describe '#constructor()', ->

        it 'should initialize resources', ->
          expect(new Registry).to.have.deep.property 'resources', {}

      describe '#isRegistered', ->

        it 'should return `true` if resource is registered', ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.resources = { ident: [resource] }

          expect(registry.isRegistered resource).to.be.true

        it 'should return `false` if resource is not registered', ->

          resource = { identifier: 'ident' }

          registry = new Registry

          expect(registry.isRegistered resource).not.to.be.true

      describe '#register', ->

        it 'should register resource', ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.register resource

          expect(registry).to.have.deep.property 'resources', { ident: [ resource ] }

        it 'should return `unregister` callback', ->

          resource = { identifier: 'ident' }

          registry = new Registry

          expect(registry.register resource).to.be.an.instanceOf Function

        it 'should emit `init` on first registration', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.on 'init', (res, reg) ->

            expect(res).to.be.equal resource
            expect(reg).to.be.equal registry

            done()

          registry.register resource

        it 'should not emit `init` on subsequent registrations', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.register { identifier: 'ident' }

          registry.on 'init', -> done Error 'Should not emit `init`'

          registry.register resource

          setTimeout done, 10

        it 'should emit `register` on first registration', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.on 'register', (res, reg) ->

            expect(res).to.be.equal resource
            expect(reg).to.be.equal registry

            done()

          registry.register resource

        it 'should emit `register` on subsequent registrations', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.register { identifier: 'ident' }

          registry.on 'register', (res, reg) ->

            expect(res).to.be.equal resource
            expect(reg).to.be.equal registry

            done()

          registry.register resource

        it 'should not register same resource twice', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.register resource

          registry.on 'register', ->
            done Error 'Should not emit for already registered resource'

          registry.register resource

          expect(registry).to.have.deep.property 'resources', { ident: [resource] }

          setTimeout done, 10

      describe '#unregister', ->

        it 'should unregister resource', ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.resources = { ident: [resource] }

          registry.unregister resource

          expect(registry).to.have.deep.property 'resources', {}

        it 'should emit `release` on last registration', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.resources = { ident: [resource] }

          registry.on 'release', (res, reg) ->
            expect(res).to.be.equal resource
            expect(reg).to.be.equal registry

            done()

          registry.unregister resource

        it 'should not emit `release` on non-last registration', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.resources = { ident: [resource, { identifier: 'ident' }] }

          registry.on 'release', -> done Error 'Should not emit `release`'

          registry.unregister resource

          expect(registry).to.have.deep.property 'resources', { ident: [{ identifier: 'ident' }]}

          setTimeout done, 10

        it 'should emit `unregister` on non-last registration', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.resources = { ident: [resource, { identifier: 'ident' }] }

          registry.on 'unregister', (res, reg) ->

            expect(res).to.be.equal resource
            expect(reg).to.be.equal registry

            done()

          registry.unregister resource

        it 'should emit `unregister` on last registration', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.unregister { identifier: 'ident' }

          registry.resources = { ident: [resource] }

          registry.on 'unregister', (res, reg) ->

            expect(res).to.be.equal resource
            expect(reg).to.be.equal registry

            done()

          registry.unregister resource

        it 'should not unregister same resource twice', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          registry.resources = { ident: [resource, { identifier: 'ident' }] }

          registry.unregister resource

          registry.on 'unregister', ->
            done Error 'Should not emit for already unregistered resource'

          registry.unregister resource

          expect(registry).to.have.deep.property 'resources', { ident: [{ identifier: 'ident' }] }

          setTimeout done, 10

      describe 'unregister callback', ->

        it 'should call `registry.unregister` with `resource`', (done) ->

          resource = { identifier: 'ident' }

          registry = new Registry

          cb = registry.register resource

          registry.unregister = (res) ->

            expect(res).to.be.equal resource

            done()

          cb()
