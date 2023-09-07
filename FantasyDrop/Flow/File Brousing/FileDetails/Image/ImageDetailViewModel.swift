//
//  ImageDetailViewModel.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 07.09.2023.
//

import UIKit

enum ImageDetailViewModelEvent {
  case imageDownloaded
  case startLoadingFile
}

class ImageDetailViewModel {
  
  let fileManager = FileManager.default
  
  var onEvent: ((ImageDetailViewModelEvent) -> ())?
  
  var path: String
  var api: Api
  
  var image: UIImage? {
    get {
      if fileManager.fileExists(atPath: fileURL.path) {
        if let content = try? Data(contentsOf: fileURL) {
          let image = UIImage(data: content)
          return image
        } else {
          return nil
        }
      } else { return nil }
    }
  }
  
  var fileURL: URL {
    get {
      let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      return directoryURL.appendingPathComponent(self.path)
    }
  }
  
  init(filePath: String, api: Api = Api()) {
    self.api = api
    self.path = filePath
    startLoadImage()
  }
  
  func startLoadImage() {
    if fileManager.fileExists(atPath: fileURL.path) {
      return
    } else {
      downloadImage(atPath: self.path)
    }
  }
  
  func downloadImage(atPath path: String) {
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.api.download(path: path) {  bool in
        if bool {
          self.onEvent?(.imageDownloaded)
        }
      }
    }
  }
  
}
