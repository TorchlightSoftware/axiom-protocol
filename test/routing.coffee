'use strict'

_ = require 'lodash'

should = require 'should'
axiom = require 'axiom'
logger = require 'torch'

protocol = require '..'

describe 'routing', ->
  beforeEach ->
    @retriever = require('axiom/test/helpers/mockRetriever')()
    axiom.wireUpLoggers [{writer: 'console', level: 'info'}]

  afterEach (done) ->
    axiom.reset(done)

  it 'should create a basic route', (done) ->

    # Given a route linking 'connect' and 'law'
    _.merge @retriever.packages,
      config:
        protocol:
          routes: [
            link: ['connect.incoming/foo', 'law.services/foo']
          ]

    axiom.init {}, @retriever

    # And a law service
    axiom.load 'law',
      services:
        'services/foo': (args, fin) ->

          # Then the service should be called
          fin()
          done()

    # When the protocol is loaded
    axiom.load 'protocol', protocol

    # And the server process is started
    axiom.request "server.run", {}, (err) ->
      should.not.exist err

      # And the 'connect' extension receives an incoming request
      axiom.request "connect.incoming/foo", {}, (err) ->
        should.not.exist err

  it 'should do nothing when there are no routes', (done) ->

    axiom.init {}, @retriever

    # When the protocol is loaded
    axiom.load 'protocol', protocol
    axiom.request "server.run", {}, done
