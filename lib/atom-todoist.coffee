module.exports =
class AtomTodoist
    constructor: (serializedState) ->
        @request = require('request')
        @main = document.createElement('div')
        @main.classList.add('atom-todoist')
        message = document.createElement('div')
        data =
            url : "https://todoist.com/API/v7/sync"
            form:
                token: atom.config.get('atom-todoist.token')
                sync_token:'*'
                resource_types:'["all"]'

        callback = (err,httpResponse,body) ->
            todo_projects = []
            todoist = JSON.parse(body)
            for i in [0...todoist.projects.length]
              for j in [0...atom.project.getPaths().length]
                atom_projects = atom.project.getPaths()[j].replace(/\\/g, '/').split("/")
                if !todoist.projects[i].inbox_project and todoist.projects[i].name.toUpperCase() == atom_projects[atom_projects.length - 1].toUpperCase()
                    todo_projects.push({id: todoist.projects[i].id, name: todoist.projects[i].name})

            for i in [0...todo_projects.length]
                for j in [0...todoist.items.length]
                    if todoist.items[j].project_id == todo_projects[i].id
                      if document.getElementById(todo_projects[i].id.toString()) == null
                        list_parent = document.createElement('ul')
                        list_parent.setAttribute('id', todo_projects[i].id.toString() + "_parent")
                        line_parent = document.createElement('li')
                        h4 = document.createElement('h4')
                        h4.textContent = todo_projects[i].name
                        line_parent.appendChild(h4)
                        list = document.createElement('ul')
                        list.setAttribute('id', todo_projects[i].id.toString())
                        list_parent.appendChild(line_parent)
                        list_parent.appendChild(list)
                        message.appendChild(list_parent)
                      parent = document.getElementById(todo_projects[i].id.toString())
                      line = document.createElement('li')
                      input = document.createElement('input')
                      input.setAttribute('type', 'checkbox')
                      input.setAttribute('id', todoist.items[j].id.toString())
                      input.checked = todoist.items[j].checked == 1
                      label = document.createElement('label')
                      label.setAttribute('for', todoist.items[j].id.toString())
                      text = document.createTextNode(" " + todoist.items[j].content)
                      label.appendChild(input)
                      label.appendChild(text)
                      line.appendChild(label)
                      parent.appendChild(line)


            message.classList.add('message')
        @request.post(data, callback)

        @main.appendChild(message)

    # Returns an object that can be retrieved when package is activated

    updateTasks: ->
      elements = document.querySelectorAll("input[type=checkbox]")
      todos = ''
      processed = 0
      request = @request
      each = (el, i, arr) ->
        if el.checked
          if todos == ''
            todos = todos + el.getAttribute('id')
          else
            todos = todos + ',' + el.getAttribute('id')

        processed++
        if processed == arr.length
          data =
            url : "https://todoist.com/API/v7/sync"
            form:
                token: atom.config.get('atom-todoist.token')
                commands: '[{"type": "item_delete", "uuid": "f8539c77-7fd7-4846-afad-3b201f0be8a5", "args": {"ids": [' + todos + ']}}]'
          callback = (err,httpResponse,body) ->
            console.log(body)
          request.post(data, callback)
      Array.prototype.forEach.call(elements, each)

    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @main.remove()

    getElement: ->
        @main
