module.exports =
class AtomTodoistView
  constructor: (serializedState) ->

    exec = require('child_process').exec
    @main = document.createElement('div')
    @main.classList.add('atom-todoist')
    message = document.createElement('div')
    output = exec("curl https://todoist.com/API/v7/sync \ -d token=" + atom.config.get('atom-todoist.token') + "\ -d sync_token='*' \ -d resource_types='[\"all\"]'")
    output.stdout.on 'data', (data) ->
      message.textContent = data
    message.classList.add('message')
    @main.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @main.remove()

  getElement: ->
    @main
