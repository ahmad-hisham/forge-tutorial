class MyViewerExtentionInToolbar extends Autodesk.Viewing.Extension {
  /*global $*/
  /*global Autodesk*/

  constructor(viewer, options) {
    super(viewer, options);
    console.log(MyViewerExtentionInToolbar.ExtensionId + ' Constructor');
    this.viewer = viewer;
  }

  static get ExtensionId() {
    return 'Autodesk.ADN.Viewing.Extension.MyViewerExtention';
  }

  load() {
    //Dynamically load the extension CSS in the DOM
    $("head").append("<link rel='stylesheet' id='MyViewerExtentionCSS' href='viewer-extension-in-toolbar.css' type='text/css' />");
    
    if (this.viewer.toolbar)
      // Toolbar is already available, create the UI
      this.createUI();
    else
      // Toolbar hasn't been created yet, wait until we get notification of its creation
      this.viewer.addEventListener(av.TOOLBAR_CREATED_EVENT, () => {this.createUI()});

    return true;
  }

  unload() {
    this.viewer.toolbar.removeControl(this.subToolbar);

    return true;
  }

  createUI() {
    var viewer = this.viewer;
  
    // Button 1
    var button1 = new Autodesk.Viewing.UI.Button('my-view-lock-button');
    button1.onClick = () => {this.lockViewport()};
    button1.addClass('my-view-lock-button');
    button1.setToolTip('Lock View');
  
    // Button 2
    var button2 = new Autodesk.Viewing.UI.Button('my-view-unlock-button');
    button2.onClick = () => {this.unlockViewport()};
    button2.addClass('my-view-unlock-button');
    button2.setToolTip('Unlock View');

    // SubToolbar
    this.subToolbar = new Autodesk.Viewing.UI.ControlGroup('my-extension-view-toolbar');
    this.subToolbar.addControl(button1);
    this.subToolbar.addControl(button2);
  
    viewer.toolbar.addControl(this.subToolbar);
  }

  lockViewport() {
    this.viewer.setNavigationLock(true);
  }

  unlockViewport() {
    this.viewer.setNavigationLock(false);
  }
}

Autodesk.Viewing.theExtensionManager.registerExtension(
  MyViewerExtentionInToolbar.ExtensionId, MyViewerExtentionInToolbar);
