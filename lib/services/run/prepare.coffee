logger = require 'torch'
connect = require 'connect'
law = require 'law'
lawAdapter = require 'law-connect'
fs = require 'fs'

module.exports =
  service: (args, done) ->

    app = connect()
    app.use (req, res, next) ->
      res.setHeader "Access-Control-Allow-Origin", "*"
      next()
    app.use connect.compress()
    app.use connect.responseTime()
    app.use connect.favicon()
    app.use connect.query()
    app.use connect.cookieParser()
    app.use connect.static @config.paths.public

    # TODO: break out into separate service, call via @axiom.request
    app.use connect.urlencoded()
    app.use connect.json()

    load = (prop) =>
      filepath = @config.law[prop]
      return @util.retrieve(filepath)

    rawServices = law.load @util.rel(@config.law.services)
    @services = law.create {
      services: rawServices
      jargon: try load('jargon')
      policy: try load('policy')
    }

    # bind all services to the axiom context
    for name, service of @services
      @services[name] = service.bind(@)

    # connect the services to REST routes
    app.use lawAdapter {
      services: @services
      routeDefs: try load('routeDefs')
      options: @config.law.adapterOptions
    }

    @app = app
    done()
