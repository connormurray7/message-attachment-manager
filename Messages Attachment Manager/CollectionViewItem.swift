/*
 * CollectionViewItem.swift
 *
 * Credit is given to Gabriel Miro for the MVC template in the SlidesMagic template
 *
 * See the AppDelegate page for more information and the copyright notice
 *
 */

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
  
  var imageFile: ImageFile? {
    didSet {
      guard viewLoaded else { return }
      if let imageFile = imageFile {
        imageView?.image = imageFile.thumbnail
        textField?.stringValue = imageFile.fileName
        textField?.textColor = NSColor.blackColor()
      } else {
        imageView?.image = nil
        textField?.stringValue = ""
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.whiteColor().CGColor
    view.layer?.borderColor = NSColor.blueColor().CGColor
  }
  
  func setHighlight(selected: Bool) {
    view.layer?.borderWidth = selected ? 5.0 : 0.0
  }
  
}