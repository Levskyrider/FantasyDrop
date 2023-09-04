//
//  Api.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit
import SwiftyDropbox

class Api {
  
  func dropboxAuth(currentController: UIViewController) {
    let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.write"], includeGrantedScopes: false)
    DropboxClientsManager.authorizeFromControllerV2(
      UIApplication.shared,
      controller: currentController,
      loadingStatusDelegate: nil,
      openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
      scopeRequest: scopeRequest
    )
  }
  
  func readFiles() {
    let client = DropboxClientsManager.authorizedClient
    client?.files.listFolder(path: "").response { response, error in
      if let result = response {
        print(result)
      } else if let error = error {
        print(error.description)
      }
    }
  }
  
}
