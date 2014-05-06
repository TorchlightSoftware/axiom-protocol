complexSignals =
  start: ['load', 'link', 'run']
  stop: ['halt', 'unlink', 'unload']

task =
  type: 'task'
  signals: complexSignals

agent =
  type: 'agent'
  signals: complexSignals

module.exports =
  protocol:

    client:
      build: task
      test: task
      run: agent
      deploy: task

    server:
      run: agent
      test: task

  attachments:
    routing: ['server.run/link', 'server.test/link']

  services:
    routing: require './services/routing'
