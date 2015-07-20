{CompositeDisposable} = require 'atom'

openFile = (uri) ->
    console.log 'Opening ' + uri
    atom.workspace.open(uri, {
        searchAllPanes: true,
        activatePane: false
    } )

module.exports = TiAlloyRelatedPlus =
  subscriptions: null

  config:
      testFilePath:
          type: 'string'
          default: ''
          title: 'Spec file path'
          description: 'This should be relaive to your base directory, ie \'test/specs\', and assumes a matching directory stucture (test/specs/controllers/indexSpec.js) '

  activate: ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ti-alloy-related-plus:openRelated': => @openRelated()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ti-alloy-related-plus:openRelatedController': => @openRelatedController()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ti-alloy-related-plus:openRelatedView': => @openRelatedView()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ti-alloy-related-plus:openRelatedStyle': => @openRelatedStyle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ti-alloy-related-plus:openRelatedSpec': => @openRelatedSpec()

  deactivate: ->
    @subscriptions.dispose()

  openRelated: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    testFilePath = atom.config.get 'ti-alloy-related-plus.testFilePath'

    if testFilePath && filePath.match(/.*Spec\.js/)
        openFile(filePath.replace(testFilePath + 'controllers/', 'app/controllers/').replace('Spec.js', '.js'))
        openFile(filePath.replace(testFilePath + 'controllers/', 'app/styles/').replace('Spec.js', '.tss'))
        openFile(filePath.replace(testFilePath + 'controllers/', 'app/views/').replace('Spec.js', '.xml'))
    else if filePath.match(/.*controller.*.js/)
        openFile(filePath.replace('app/controllers/', 'app/views/').replace('.js', '.xml'))
        openFile(filePath.replace('app/controllers/', 'app/styles/').replace('.js', '.tss'))
        if testFilePath
            openFile(filePath.replace('app/controllers/', testFilePath + 'controllers/').replace('.js', 'Spec.js'))
    else if filePath.match(/.*styles.*.tss/)
        openFile(filePath.replace('app/styles/', 'app/controllers/').replace('.tss', '.js'))
        openFile(filePath.replace('app/styles/', 'app/views/').replace('.tss', '.xml'))
        if testFilePath
            openFile(filePath.replace('app/styles/', testFilePath + 'controllers/').replace('.tss', 'Spec.js'))
    else if filePath.match(/.*views.*.xml/)
        openFile(filePath.replace('app/views/', 'app/controllers/').replace('.xml', '.js'))
        openFile(filePath.replace('app/views/', 'app/styles/').replace('.xml', '.tss'))
        if testFilePath
            openFile(filePath.replace('app/views/', testFilePath + 'controllers/').replace('.xml', 'Spec.js'))

  openRelatedController: ->
    console.log 'Open related controller'
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    testFilePath = atom.config.get 'ti-alloy-related-plus.testFilePath'

    if testFilePath && filePath.match(/.*Spec\.js/)
      openFile(filePath.replace(testFilePath + 'controllers/', 'app/controllers/').replace('Spec.js', '.js'))
    else if filePath.match(/.*styles.*.tss/)
      openFile(filePath.replace('app/styles/', 'app/controllers/').replace('.tss', '.js'))
    else if filePath.match(/.*views.*.xml/)
      openFile(filePath.replace('app/views/', 'app/controllers/').replace('.xml', '.js'))

  openRelatedView: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    testFilePath = atom.config.get 'ti-alloy-related-plus.testFilePath'

    if testFilePath && filePath.match(/.*Spec\.js/)
      openFile(filePath.replace(testFilePath + 'controllers/', 'app/views/').replace('Spec.js', '.xml'))
    else if filePath.match(/.*styles.*.tss/)
      openFile(filePath.replace('app/styles/', 'app/views/').replace('.tss', '.xml'))
    else if filePath.match(/.*controllers.*.js/)
      openFile(filePath.replace('app/controllers/', 'app/views/').replace('.js', '.xml'))

  openRelatedStyle: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    testFilePath = atom.config.get 'ti-alloy-related-plus.testFilePath'

    if testFilePath && filePath.match(/.*Spec\.js/)
      openFile(filePath.replace(testFilePath + 'controllers/', 'app/styles/').replace('Spec.js', '.tss'))
    else if filePath.match(/.*views.*.xml/)
      openFile(filePath.replace('app/views/', 'app/styles/').replace('.xml', '.tss'))
    else if filePath.match(/.*controllers.*.js/)
      openFile(filePath.replace('app/controllers/', 'app/styles/').replace('.js', '.tss'))

  openRelatedSpec: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    testFilePath = atom.config.get 'ti-alloy-related-plus.testFilePath'

    if testFilePath
      if filePath.match(/.*styles.*\.tss/)
        openFile(filePath.replace('app/styles/', testFilePath + 'controllers/').replace('.tss', 'Spec.js'))
      else if filePath.match(/.*views.*.xml/)
        openFile(filePath.replace('app/views/', testFilePath + 'controllers/').replace('.xml', 'Spec.js'))
      else if filePath.match(/.*controllers.*.js/)
        openFile(filePath.replace('app/controllers/', testFilePath + 'controllers/').replace('.js', 'Spec.js'))
