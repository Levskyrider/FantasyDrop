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
  
  var asset: AVAsset? {
    get {
      let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let fileURL = directoryURL.appendingPathComponent(self.path)
      if fileManager.fileExists(atPath: fileURL.path) {
        let asset = AVAsset(url: fileURL)
        return asset
      } else {
        downloadVideo(atPath: self.path)
        return nil
      }
    }
  }
  
  init(filePath: String, api: Api = Api()) {
    self.api = api
    self.path = filePath
  }
  
  func downloadVideo(atPath path: String) {
    api.download(path: path) { [weak self] bool in
      if bool {
      //  self?.onEvent?(.imageDownloaded)
      }
    }
  }
  
}
