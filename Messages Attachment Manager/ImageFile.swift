/*
 * ImageFile.swift
 *
 * Credit is given to Gabriel Miro for the MVC template in the SlidesMagic template
 *
 * See the AppDelegate page for more information and the copyright notice
 *
 */

import Cocoa

struct InfoStruct {
    var fullPath: NSURL!
    var GUID = ""
    var name = ""
}

class ImageFile {
  
  private(set) var thumbnail: NSImage?
  private(set) var fileName: String
  var info: InfoStruct
  
  init (url: NSURL) {
    if let name = url.lastPathComponent {
      fileName = name
    } else {
      fileName = ""
    }
    var splitString = url.absoluteString.componentsSeparatedByString("/")
    info = InfoStruct(fullPath: url, GUID: splitString[splitString.count-2], name: fileName)
    let imageSource = CGImageSourceCreateWithURL(url.absoluteURL, nil)
    if let imageSource = imageSource {
      guard CGImageSourceGetType(imageSource) != nil else { return }
      thumbnail = getThumbnailImage(imageSource)
    }
  }
  
  private func getThumbnailImage(imageSource: CGImageSource) -> NSImage? {
    let thumbnailOptions = [
      String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
      String(kCGImageSourceThumbnailMaxPixelSize): 160
    ]
    guard let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions) else { return nil}
    return NSImage(CGImage: thumbnailRef, size: NSSize.zero)
  }
}
