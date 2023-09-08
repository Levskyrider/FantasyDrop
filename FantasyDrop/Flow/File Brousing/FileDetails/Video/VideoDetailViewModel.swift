//
//  VideoDetailViewModel.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 07.09.2023.
//

import UIKit
import AVFoundation

enum VideoDetailViewModelEvent {
  case startLoadingFile
  case videoDownloaded
}

class VideoDetailViewModel {
  
  let fileManager = FileManager.default
  
  var onEvent: ((VideoDetailViewModelEvent) -> ())?
  
  var path: String
  var api: Api
  
  var assetURL: URL? {
    get {
      let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let fileURL = directoryURL.appendingPathComponent(self.path)
      if fileManager.fileExists(atPath: fileURL.path) {
        return fileURL
      } else {
        downloadVideo(atPath: self.path)
        return nil
      }
    }
  }
  
  func startLoadVideo() {
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = directoryURL.appendingPathComponent(self.path)
    if fileManager.fileExists(atPath: fileURL.path) {
      return
    } else {
      downloadVideo(atPath: self.path)
    }
  }
  
  init(filePath: String, api: Api = Api()) {
    self.api = api
    self.path = filePath
    startLoadVideo()
  }
  
  func downloadVideo(atPath path: String) {
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.api.download(path: path) { result in
        switch result {
        case .success(let _):
          self.onEvent?(.videoDownloaded)
        case .error(let errorDescription):
          print(errorDescription)
        }
      }
    }
  }
  
}
