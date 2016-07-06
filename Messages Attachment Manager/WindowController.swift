/*
 * WindowController.swift
 *
 * Credit is given to Gabriel Miro for the MVC template in the SlidesMagic template
 *
 * See the AppDelegate page for more information and the copyright notice
 *
 */

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window, let screen = NSScreen.mainScreen() {
            
            let screenRect = screen.visibleFrame
            let width = screenRect.width
            let height = screenRect.height
            window.setFrame(NSRect(x: screenRect.origin.x + width/8.0, y: screenRect.origin.y + height/8.0, width: screenRect.width*0.75, height: screenRect.height*0.75), display: true)
        }
}
  
    @IBAction func openAnotherFolder(sender: AnyObject) {
    
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories  = true
        openPanel.canChooseFiles        = false
        openPanel.showsHiddenFiles      = false
        
        openPanel.beginSheetModalForWindow(self.window!) { (response) -> Void in
            guard response == NSFileHandlingPanelOKButton else {return}
            let viewController = self.contentViewController as? ViewController
            if let viewController = viewController, let URL = openPanel.URL {
                viewController.loadDataForNewFolderWithUrl(URL)
            }
        }
    }
}
