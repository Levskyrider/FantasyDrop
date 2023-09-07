//
//  FileCellViewModel.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 05.09.2023.
//

import UIKit
import SwiftyDropbox

enum FileType {
  case image
  case video
  case other
}

enum FileCellViewModelEvent {
  case shouldOpen(FileType, String)
  case loadedImage(UIImage?)
}

class FileCellViewModel {
  
  var onEvent: ((FileCellViewModelEvent) -> ())?
  
  var imageMiniature: UIImage? {
    get {
      ThumbnailManager.shared[path]
    }
  }
  var path: String
  var fileType: FileType = .other
  var fileExtension: String? = ""
    
  func setImageMiniature() {
    onEvent?(.loadedImage(imageMiniature))
  }
  
  init(path: String) {
    self.path = path
    let fileExtension = path.components(separatedBy: ".").last
    self.fileExtension = fileExtension
    switch fileExtension {
    case "mp4":
      self.fileType = .video
    case "png", "jpeg":
      self.fileType = .image
    default:
      self.fileType = .other
    }
  }
  
}
