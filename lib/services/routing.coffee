logger = require 'torch'

module.exports =
  service: (args, done) ->

    # read through all the routes in the config
    if @config.routes
      for route in @config.routes
        for type, endpoints of route

          # wire up each type of route
          switch type
            when 'link'
              [from, to] = endpoints
              @axiom.link from, to

    done()
