AtomTodoistView = require './atom-todoist-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomTodoist =
    atomTodoistView: null
    modalPanel: null
    subscriptions: null

    config:
        token:
            type: 'string'
            default: ''
            title:'Token Todoist'
            description: 'Insert the Todoist API Token'

    activate: (state) ->
        @atomTodoistView = new AtomTodoistView(state.atomTodoistViewState)
        @modalPanel = atom.workspace.addModalPanel(item: @atomTodoistView.getElement(), visible: false)

        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @subscriptions = new CompositeDisposable

        # Register command that toggles this view
        @subscriptions.add atom.commands.add 'atom-workspace', 'atom-todoist:toggle': => @toggle()

    deactivate: ->
        @modalPanel.destroy()
        @subscriptions.dispose()
        @atomTodoistView.destroy()

    serialize: ->
        atomTodoistViewState: @atomTodoistView.serialize()

    toggle: ->
        if @modalPanel.isVisible()
            @modalPanel.hide()
        else
            @modalPanel.show()
