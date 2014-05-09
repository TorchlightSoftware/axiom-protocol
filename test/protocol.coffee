path = require 'path'
fs = require 'fs'

should = require 'should'
axiom = require 'axiom'
logger = require 'torch'

protocol = require '..'

retriever = require('axiom/test/helpers/mockRetriever')()

describe 'protocol', ->
  beforeEach ->
    axiom.wireUpLoggers [{writer: 'console', level: 'info'}]
    axiom.init {}, retriever
    axiom.load 'protocol', protocol

  afterEach (done) ->
    axiom.reset(done)

  it 'should register server/run', (done) ->
    axiom.request "server.run", {}, done
