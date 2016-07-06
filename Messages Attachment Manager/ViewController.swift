/*
* ViewController.swift
*
* Credit is given to Gabriel Miro for the MVC template in the SlidesMagic template
*
* The major adjustments I made was incorporating the SQL to properly delete
* the attachments and changing how the icons appear. I also added multi select support,
* more buttons, and other options
*
* See the AppDelegate page for more information.
*/

import Cocoa

class ViewController: NSViewController {
    
    let imageDirectoryLoader = ImageDirectoryLoader()
  
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var totalSize: NSTextField!
    
    @IBAction func sortByExt(sender: NSButton) {
        imageDirectoryLoader.singleSectionMode = (sender.state == 0) ? true : false;
        imageDirectoryLoader.setupDataForUrls(nil)
        collectionView.reloadData()
    }
  
    @IBAction func deleteSelected(sender: NSButton) {
        imageDirectoryLoader.deleteForIndexPaths(collectionView.selectionIndexPaths)
        collectionView.reloadData()
        collectionView.deselectAll(ViewController)
    }
    @IBAction func selectAllItems(sender: AnyObject) {
        let selectAll = (sender as! NSButton).state
        if selectAll == NSOnState {
            collectionView.reloadData()
            collectionView.selectAll(ViewController)
        }
        else {
            collectionView.reloadData()
            collectionView.deselectAll(ViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialFolderUrl = NSURL.fileURLWithPath("\(NSHomeDirectory())/Library/Messages/Attachments", isDirectory: true)
        imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
        totalSize.stringValue = String(imageDirectoryLoader.getTotalSizeInBytes()/1000000) + " MB Total"
        configureCollectionView()
    }
    
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
        collectionView.reloadData()
    }
    private func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        collectionView.allowsMultipleSelection = true
    }
    
}

extension ViewController : NSCollectionViewDataSource {
  
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return imageDirectoryLoader.numberOfSections
    }
  
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectoryLoader.numberOfItemsInSection(section)
    }
  
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
    
        let item = collectionView.makeItemWithIdentifier("CollectionViewItem", forIndexPath: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
    
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        collectionViewItem.imageFile = imageFile
    
        if collectionView.selectionIndexPaths.contains(indexPath) {
            collectionViewItem.setHighlight(true)
        } else {
            collectionViewItem.setHighlight(false)
        }
        return item
    }
  
  func collectionView(collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> NSView {
    let view = collectionView.makeSupplementaryViewOfKind(NSCollectionElementKindSectionHeader, withIdentifier: "HeaderView", forIndexPath: indexPath) as! HeaderView
    
    let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(indexPath.section)
    if(indexPath.section == 0) {
        view.sectionTitle.stringValue = "Image Attachments"
        view.imageCount.stringValue = "\(numberOfItemsInSection) image files"
    }
    else if(indexPath.section == 1) {
        view.sectionTitle.stringValue = "Video and Audio Attachments"
        view.imageCount.stringValue = "\(numberOfItemsInSection) video/audio files"
    }
    else {
        view.sectionTitle.stringValue = "Other Attachments"
        view.imageCount.stringValue = "\(numberOfItemsInSection) other files"
    }
    
    return view
  }
}

extension ViewController : NSCollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
    return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
  }
  
}

extension ViewController : NSCollectionViewDelegate {
  
  func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
    for i in indexPaths {
      guard let item = collectionView.itemAtIndexPath(i) else {return}
      (item as! CollectionViewItem).setHighlight(true)
    }
  }
  
  func collectionView(collectionView: NSCollectionView, didDeselectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
    for i in indexPaths {
      guard let item = collectionView.itemAtIndexPath(i) else {return}
      (item as! CollectionViewItem).setHighlight(false)
    }
  }
}

