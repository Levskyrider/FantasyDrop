//
//  Api.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit
import SwiftyDropbox

enum DropboxResult<T> {
  case success(T)
  case error(String)
}

class Api {
  
  let appKey = "jzyx97e49hv14r5"
  let appSecret = "osxwb9bhuyypr8e"
  
  var permanentRefreshToken: String?
  
  var accessToken: String? {
    didSet {
      if let token = accessToken {
        DropboxClientsManager.authorizedClient = DropboxClient(accessToken: token)
      }
    }
  }
  
  var client: DropboxClient? {
    get {
        return DropboxClientsManager.authorizedClient
    }
  }
  
  var thumbnailManager = ThumbnailManager.shared
  
  init(accessToken: String? = nil, refreshToken: String? = nil) {
    DropboxClientsManager.authorizedClient = nil
    self.accessToken = accessToken
    self.permanentRefreshToken = refreshToken
    if let accessToken = accessToken {
      DropboxClientsManager.authorizedClient = DropboxClient(accessToken: accessToken)
    }
  }
  
  func refreshToken(completion: (() -> ())? = nil) {
    guard let tokenURL = URL(string: "https://api.dropbox.com/oauth2/token") else { return }
    
    var request = URLRequest(url: tokenURL)
    request.httpMethod = "POST"
 //   print(permanentRefreshToken)
    let parameters = [
        "refresh_token": permanentRefreshToken!,
        "grant_type": "refresh_token",
        "client_id": appKey,
        "client_secret": appSecret
    ]
    
    let params = "refresh_token=\(permanentRefreshToken!)&grant_type=refresh_token&client_id=\(appKey)&client_secret=\(appSecret)"
    
    if let requestData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
      request.httpBody = params.description.data(using: .ascii)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(responseJSON)")
                  
                  let token = responseJSON["access_token"] as? String
                  let expiresIn = responseJSON["expires_in"] as? TimeInterval
                  self?.setWithNew(accessToken: token, nextExpiresIn: expiresIn, completion: completion)
                }
            }
        }

        task.resume()
    } else {
      print("Error creating request data")
    }
    
  }
  
  private func setWithNew(accessToken: String?, nextExpiresIn: TimeInterval?, completion: (() -> ())? = nil) {
    self.accessToken = accessToken
    if let interval = nextExpiresIn {
      let _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
        guard let self = self else { return }
        self.refreshToken()
      }
    }
    completion?()
  }
  
  func dropboxAuth(currentController: UIViewController, scopes: [String] = ["account_info.read", "files.content.write", "files.content.read"]) {
    let scopeRequest = ScopeRequest(scopeType: .user, scopes: scopes, includeGrantedScopes: false)
    DropboxClientsManager.authorizeFromControllerV2(
      UIApplication.shared,
      controller: currentController,
      loadingStatusDelegate: nil,
      openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
      scopeRequest: scopeRequest
    )
  }
  
  func loadFilesList(completion: @escaping ((DropboxResult<Array<Files.Metadata>>) -> ())) {
   // DropboxClientsManager.authorizedClient = nil
    if client == nil {
      refreshToken {
        self.loadFilesList(completion: completion)
      }
      return
    }
    client!.files.listFolder(path: "").response { response, error in
      if let result = response {
        print(result.entries)
        completion(.success(result.entries))
      } else if let error = error {
        completion(.error(error.description))
      }
    }
  }
  
  
 
  func download(path: String, completion: @escaping ((Bool) -> ())) {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent(path)
    let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
      return destURL
    }
    client?.files.download(path: path, overwrite: true, destination: destination)
      .response { response, error in
        if let response = response {
          print(response)
          completion(true)
        } else if let error = error {
          print(error)
        }
      }
      .progress { progressData in
        print(progressData)
      }
  }
  
}
