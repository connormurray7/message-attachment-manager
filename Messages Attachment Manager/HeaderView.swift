/*
 * HeaderView.swift
 *
 * Credit is given to Gabriel Miro for the MVC template in the SlidesMagic template
 *
 * See the AppDelegate page for more information and the copyright notice
 *
 */

import Cocoa

class HeaderView: NSView {

  @IBOutlet weak var sectionTitle: NSTextField!
  @IBOutlet weak var imageCount: NSTextField!
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    NSColor(calibratedWhite: 0.8 , alpha: 0.8).set()
    NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.CompositeSourceOver)
  }
}
