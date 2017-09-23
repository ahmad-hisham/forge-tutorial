class MyViewerExtention extends Autodesk.Viewing.Extension {
  /*global $*/
  /*global Autodesk*/

  constructor(viewer, options) {
    super(viewer, options);
    this.viewer = viewer;

    console.log(MyViewerExtention.ExtensionId + ' Constructor');
  }

  static get ExtensionId() {
    return 'Autodesk.ADN.Viewing.Extension.MyViewerExtention';
  }

  load() {
    var extensionUI = $('#MyViewerExtension');

    extensionUI.append('<button id="MyLockButton">Lock</button>');
    extensionUI.append('<button id="MyUnlockButton">Unlock</button>');

    $('#MyLockButton').on('click', (e) => {this.lockViewport(e)});  //Use arrow functions instead of binding event handler to keep this to class
    $('#MyUnlockButton').on('click', (e) => {this.unlockViewport(e)});

    return true;
  }

  unload() {
    $('#MyViewerExtension').empty();

    return true;
  }

  lockViewport(e) {
    console.log(e);
    this.viewer.setNavigationLock(true);
  }

  unlockViewport() {
    this.viewer.setNavigationLock(false);
  }
}

Autodesk.Viewing.theExtensionManager.registerExtension(MyViewerExtention.ExtensionId, MyViewerExtention);
