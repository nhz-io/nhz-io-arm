# Resource tests

    should = (require 'chai').should()

    Resource = require '../src/Resource'

    describe 'Resource', ->

      describe '#constructor()', ->

        it 'should throw without identifier', ->
          should.Throw -> new Resource

        it 'should use provided identifier', ->
          (new Resource 'ident').identifier.should.equal 'ident'
