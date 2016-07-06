/*
 * ImageDirectoryLoader.swift
 *
 * Credit is given to Gabriel Miro for the MVC template in the SlidesMagic template
 *
 * See the AppDelegate page for more information and the copyright notice
 *
 */

import Cocoa

class ImageDirectoryLoader: NSObject {
    
    private var imageFiles = [ImageFile]()
    private let databaseManager = DatabaseManager()
    private let fileMgr = NSFileManager.defaultManager()
    private let trashPath = NSURL(fileURLWithPath: "\(NSHomeDirectory())/.Trash/Deleted_Attachments/", isDirectory: true)
    private var totalSizeInBytes = Int64(0)
    public let numberOfSections = 3
    
    private var imageArray:         [ImageFile] = []
    private var videoAndAudioArray: [ImageFile] = []
    private var otherArray:         [ImageFile] = []
    
    var singleSectionMode = false
    
    func getTotalSizeInBytes() -> Int64 {
        return totalSizeInBytes
    }

    func loadDataForFolderWithUrl(folderURL: NSURL) {
        let urls = getFilesURLFromFolder(folderURL)
        setupDataForUrls(urls)
    }
  
    func setupDataForUrls(urls: [NSURL]?) {
        if let urls = urls {
            createImageFilesForUrls(urls)
        }
    }
    
    private func createImageFilesForUrls(urls: [NSURL]) {
        if imageFiles.count > 0 {
            imageFiles.removeAll()
        }
        var s = ""
        for url in urls {
            s = url.pathExtension!.lowercaseString
            let imageFile = ImageFile(url: url)
            
            if(s == "jpeg" || s == "jpg" || s == "png") {
                imageArray.append(imageFile)
            }
            else if(s == "mov" || s == "mp3") {
                videoAndAudioArray.append(imageFile)
            }
            else {
                otherArray.append(imageFile)
            }
        }
    }
  
    private func getFilesURLFromFolder(folderURL: NSURL) -> [NSURL]? {
    
        let options: NSDirectoryEnumerationOptions = [.SkipsHiddenFiles, .SkipsPackageDescendants]
        let fileManager = NSFileManager.defaultManager()
        let resourceValueKeys = [NSURLIsRegularFileKey, NSURLTypeIdentifierKey]
    
        guard let directoryEnumerator = fileManager.enumeratorAtURL(folderURL, includingPropertiesForKeys: resourceValueKeys,
                                                                    options: options, errorHandler:
            { url, error in
                print("`directoryEnumerator` error: \(error).")
                return true
            }) else { return nil }
    
        var urls: [NSURL] = []
        var dict: NSDictionary?
        var tmpNum: NSNumber?
        for case let url as NSURL in directoryEnumerator {
            do {
                let resourceValues = try url.resourceValuesForKeys(resourceValueKeys)
                guard let isRegularFileResourceValue = resourceValues[NSURLIsRegularFileKey] as? NSNumber else { continue }
                guard isRegularFileResourceValue.boolValue else { continue }
                urls.append(url)
                try dict = fileMgr.attributesOfItemAtPath(url.path!)
                tmpNum = dict?.objectForKey(NSFileSize) as? NSNumber
                totalSizeInBytes += (tmpNum?.longLongValue)!
            }
            catch {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
  
    func numberOfItemsInSection(section: Int) -> Int {
        if section == 0 { // Images
            return imageArray.count
        }
        if section == 1 { // Movies/audio
            return videoAndAudioArray.count
        }
        if section == 2 { // Other
            return otherArray.count
        }
        return 0 // Should never get here, but 0 otherwise
    }
  
    func imageFileForIndexPath(indexPath: NSIndexPath) -> ImageFile {
        if(indexPath.section == 0) { // Images
            return imageArray[indexPath.item]
        }
        if(indexPath.section == 1) { // Movies/audio
            return videoAndAudioArray[indexPath.item]
        }
        if(indexPath.section == 2) { // Other
            return otherArray[indexPath.item] // Should never get here.
        }
        print("Requested image with out of range index path: " + String(indexPath.item))
        return ImageFile(url: NSURL(fileURLWithPath: ""))
    }
    func infoForIndexPath(indexPath: NSIndexPath) -> InfoStruct {
        if(indexPath.section == 0) { // Images
            return imageArray[indexPath.item].info
        }
        if(indexPath.section == 1) { // Movies/audio
            return videoAndAudioArray[indexPath.item].info
        }
        if(indexPath.section == 2) { // Other
            return otherArray[indexPath.item].info
        }
        print("Requested image with out of range index path: " + String(indexPath.item))
        return InfoStruct()
    }
    
    func deleteForIndexPaths(indexPaths: Set<NSIndexPath>) {
        var file: InfoStruct
        var isDir : ObjCBool = true
        //This creates the directory to move the attachments to.
        if(!fileMgr.fileExistsAtPath(trashPath.absoluteString, isDirectory: &isDir)) {
            do {
                try fileMgr.createDirectoryAtPath(trashPath.absoluteString, withIntermediateDirectories: false, attributes: [:])
            }
            catch {
                print("Could not create directory")
        }
    }
    //THIS MUST EXECUTE
    databaseManager.prepareForDeletes()
    for i in indexPaths {
        file = infoForIndexPath(i)
        // Move the files to the trash.
        do {
            try fileMgr.moveItemAtURL(file.fullPath, toURL: NSURL(fileURLWithPath: file.name, relativeToURL: trashPath))
        }
        catch let error as NSError {
            print("Here is the error: \(error)")
        }
        // Delete from the database.
        databaseManager.deleteByGUID(file.GUID)
    }
    //AND THIS MUST EXECUTE
    databaseManager.finishedDeleting()
  }
}