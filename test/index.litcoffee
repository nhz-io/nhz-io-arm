# Index test

    index = require '../src/index'

    Manager = require '../src/Manager'
    Registry = require '../src/Registry'
    Resource = require '../src/Resource'

    describe 'index', ->

      it 'should export Manager', -> expect(index.Manager).to.be.equal Manager

      it 'should export Registry', -> expect(index.Registry).to.be.equal Registry

      it 'should export Resource', -> expect(index.Resource).to.be.equal Resource
