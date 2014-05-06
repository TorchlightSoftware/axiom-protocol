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

  afterEach ->
    axiom.reset()

  it 'should create a basic route', (done) ->

    # Given a route linking 'connect' and 'law'
    _.merge @retriever.packages,
      axiom_configs:
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
      #axiom.request "law.services/foo", {}, (err) ->

      axiom.request "connect.incoming/foo", {}, (err) ->
        should.not.exist err
