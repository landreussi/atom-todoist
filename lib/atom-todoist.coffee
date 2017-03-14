AtomTodoistView = require './atom-todoist-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomTodoist =
    atomTodoistView: null
    rightPanel: null
    subscriptions: null
    toggled: false
    config:
        token:
            type: 'string'
            default: ''
            title:'Token Todoist'
            description: 'Insert the Todoist API Token'

    activate: (state) ->
        @atomTodoistView = new AtomTodoistView(state.atomTodoistViewState)
        @rightPanel = atom.workspace.addRightPanel(item: @atomTodoistView.getElement(), visible: false)
        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @subscriptions = new CompositeDisposable

        # Register command that toggles this view
        @subscriptions.add atom.commands.add 'atom-workspace', 'atom-todoist:toggle': => @toggle(state)

    deactivate: ->
        @rightPanel.destroy()
        @subscriptions.dispose()
        @atomTodoistView.destroy()

    serialize: ->
        atomTodoistViewState: @atomTodoistView.serialize()

    toggle: (state)->
        if @toggled
          @toggled = false
          @rightPanel.destroy()
          @atomTodoistView.destroy()
        else
          @toggled = true
          @atomTodoistView = new AtomTodoistView(state.atomTodoistViewState)
          @rightPanel = atom.workspace.addRightPanel(item: @atomTodoistView.getElement(), visible: false)
          @rightPanel.show()
