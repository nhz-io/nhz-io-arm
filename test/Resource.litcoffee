# Resource tests

    { EventEmitter } = require 'events'

    should = (require 'chai').should()

    Resource = require '../src/Resource'

    describe 'Resource', ->

      it 'should be subclass of EventEmitter', ->
        expect(EventEmitter.prototype.isPrototypeOf Resource.prototype).to.be.true

      describe '#constructor()', ->

        it 'should throw without identifier', ->
          should.Throw -> new Resource

        it 'should use provided identifier', ->
          (new Resource 'ident').identifier.should.equal 'ident'
