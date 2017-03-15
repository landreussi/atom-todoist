AtomTodoist = require './atom-todoist'
{CompositeDisposable} = require 'atom'

module.exports = Main =
    atomTodoist: null
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
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add 'atom-workspace', 'main:toggle': => @toggle(state)

    deactivate: ->
        @rightPanel.destroy()
        @subscriptions.dispose()
        @atomTodoist.destroy()

    serialize: ->
        atomTodoistState: @atomTodoist.serialize()

    toggle: (state)->
        if atom.config.get('atom-todoist.token') == ''
          atom.notifications.addFatalError("Error", detail: "Todoist could not find any token\nPlease insert your todoist token into the settings")
        else
          if @toggled
            @toggled = false
            @atomTodoist.updateTasks()
            @rightPanel.destroy()
            @atomTodoist.destroy()
          else
            @toggled = true
            @atomTodoist = new AtomTodoist(state.atomTodoistState)
            @rightPanel = atom.workspace.addRightPanel(item: @atomTodoist.getElement(), visible: false)
            @rightPanel.show()
