
module.exports =
class AtomTodoistView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-todoist')

    # Create message element
    message = document.createElement('div')
    message.textContent = "the token is " + atom.config.get('atom-todoist.token')
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
