# Resource

    class Resource then constructor: (identifier) ->

      throw TypeError 'Missing identifier' unless identifier

      @identifier = identifier

    module.exports = Resource