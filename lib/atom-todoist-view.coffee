module.exports =
class AtomTodoistView
    constructor: (serializedState) ->
        request = require('request')
        @main = document.createElement('div')
        @main.classList.add('atom-todoist')
        message = document.createElement('div')
        list = document.createElement('ul')
        data =
            url : "https://todoist.com/API/v7/sync"
            form:
                token: atom.config.get('atom-todoist.token')
                sync_token:'*'
                resource_types:'["all"]'

        callback = (err,httpResponse,body) ->
            project_id = []
            todoist = JSON.parse(body)
            for i in [0...todoist.projects.length]
              for j in [0...atom.project.getPaths().length]
                atom_projects = atom.project.getPaths()[j].split("/")
                if !todoist.projects[i].inbox_project and todoist.projects[i].name.toUpperCase() == atom_projects[atom_projects.length - 1].toUpperCase()
                    project_id.push(todoist.projects[i].id);

            for i in [0...project_id.length]
                for j in [0...todoist.items.length]
                    if todoist.items[j].id = project_id[i]
                      line = document.createElement('li')
                      line.textContent = todoist.items[j].content
                      list.appendChild(line)

        message.appendChild(list)
        message.classList.add('message')
        request.post(data, callback)

        @main.appendChild(message)

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @main.remove()

    getElement: ->
        @main
