standardSignals =
  start: ['load', 'link', 'run']
  stop: ['halt', 'unlink', 'unload']

task =
  type: 'task'
  signals: standardSignals

agent =
  type: 'agent'
  signals: standardSignals

test =
  type: 'task'
  start: ['load', 'link', 'run']
  runSuite: ['before', 'beforeEach', 'afterEach', 'after']
  stop: ['halt', 'unlink', 'unload']

module.exports =
  protocol:

    client:
      build: task
      test: test
      run: agent
      deploy: task

    server:
      run: agent
      test: task

    db:
      seed: task
