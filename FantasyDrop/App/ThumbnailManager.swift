//
//  ThumbnailManager.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 06.09.2023.
//

import UIKit
import SwiftyDropbox

class ThumbnailManager {
  
  var client: DropboxClient? {
    get {
      return DropboxClientsManager.authorizedClient
    }
  }
  
  static var shared: ThumbnailManager = {
    let instance = ThumbnailManager()
    return instance
  }()
  
  private init() {}
  
  private var cashe: [String: UIImage?] = [:]
  
  subscript (path: String) -> UIImage? {
    return cashe[path] ?? nil
  }
  
  func removeImage(atPath path: String) {
    cashe[path] = nil
  }
  
  func cleanCache() {
    cashe = [:]
  }
  
  func getTHumbnail(path: String, completion: ((DropboxResult<UIImage?>) -> ())?) {
    client?.files.getThumbnail(path: path, size: .w256h256).response { [weak self] response, error in
      if let response = response {
        let image = UIImage(data: response.1)
        self?.cashe[path] = image
        completion?(.success(image))
      }
      if let error = error {
        completion?(.error(error.description))
        return
      }
    }
  }
  
}

extension ThumbnailManager: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
