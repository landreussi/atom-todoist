AtomTodoist = require '../lib/atom-todoist'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomTodoist", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atom-todoist')
    atom.config.set('atom-todoist.token', '34cfbe090c52239a5eca49017bce6b0f585752ff')

  describe "when the atom-todoist:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created (actually it will toggle itself when get activated)
      atomTodoistElement = workspaceElement.querySelector('.atom-todoist')
      expect(atomTodoistElement).toExist()

      atomTodoistPanel = atom.workspace.panelForItem(atomTodoistElement)
      expect(atomTodoistPanel.isVisible()).toBe true      

      waitsForPromise ->
        activationPromise

      runs ->
        atom.commands.dispatch workspaceElement, 'atom-todoist:toggle'
        expect(atomTodoistPanel.isVisible()).toBe false
        expect(workspaceElement.querySelector('.atom-todoist')).not.toExist()

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.atom-todoist')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'atom-todoist:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        atomTodoistElement = workspaceElement.querySelector('.atom-todoist')
        expect(atomTodoistElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'atom-todoist:toggle'
        expect(atomTodoistElement).not.toBeVisible()
