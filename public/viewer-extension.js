function MyAwesomeExtension(viewer, options) {
  Autodesk.Viewing.Extension.call(this, viewer, options);
}

MyAwesomeExtension.prototype = Object.create(Autodesk.Viewing.Extension.prototype);
MyAwesomeExtension.prototype.constructor = MyAwesomeExtension;

MyAwesomeExtension.prototype.load = function() {

  // function.bind emits a new function that has its 'this' set to what bind have selected
  // In an eventHandler, 'this' normally refers to the element that fired the event, not the class
  this.onLockBinded = this.lockViewport.bind(this);
  this.onUnlockBinded = this.unlockViewport.bind(this);

  var extensionUI = document.getElementById('MyViewerExtension');

  var lockBtn = document.createElement('button');
  lockBtn.id = "MyAwesomeLockButton";
  lockBtn.textContent = "Lock it!";
  lockBtn.addEventListener('click', this.onLockBinded);
  extensionUI.appendChild(lockBtn);

  var unlockBtn = document.createElement('button');
  unlockBtn.id = "MyAwesomeUnlockButton";
  unlockBtn.textContent = "Unlock it!";
  unlockBtn.addEventListener('click', this.onUnlockBinded);
  extensionUI.appendChild(unlockBtn);

  return true;
};

MyAwesomeExtension.prototype.unload = function() {
  // alert('MyAwesomeExtension is now unloaded!');

  var lockBtn = document.getElementById('MyAwesomeLockButton');
  lockBtn.removeEventListener('click', this.onLockBinded);

  var unlockBtn = document.getElementById('MyAwesomeUnlockButton');
  unlockBtn.removeEventListener('click', this.onUnlockBinded);

  this.onLockBinded = null;
  this.onUnlockBinded = null;

  return true;
};

MyAwesomeExtension.prototype.lockViewport = function() {
  this.viewer.setNavigationLock(true);
};

MyAwesomeExtension.prototype.unlockViewport = function() {
  this.viewer.setNavigationLock(false);
};

Autodesk.Viewing.theExtensionManager.registerExtension('Autodesk.ADN.Viewing.Extension.MyViewerExtention', MyAwesomeExtension);
