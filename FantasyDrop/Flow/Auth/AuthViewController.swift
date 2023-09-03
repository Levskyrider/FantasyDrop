//
//  AuthViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit
import SwiftyDropbox

enum AuthViewControllerEvent {
  case loggedIn
}

class AuthViewController: UIViewController {
  
  //MARK: - Variables
  
  var onEvent: ((AuthViewControllerEvent) -> ())?
  var viewModel: AuthViewModel!
  
  //MARK: - UI
  
  var authButton: UIButton = {
    let button = UIButton()
    button.setTitle("Start auth", for: .normal)
    return button
  }()
  
  //MARK: - Init
  
  init(viewModel: AuthViewModel) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
    bind()
  }
  
  //MARK: - Setup UI
  
  func setupUI() {
    self.view.addSubview(authButton)
    authButton.snp.makeConstraints { make in
      make.center.equalTo(self.view.center)
    }
  }
  
  //MARK: - Bindings
  
  func bind() {
    authButton.addTarget(self, action: #selector(startAuth), for: .touchUpInside)
  }
  
  //MARK: - UI logic
  
  @objc func startAuth() {
    dropboxAuth()
  }

}

//MARK: - Dropbox auth

extension AuthViewController {
  
  func dropboxAuth() {
    // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
    let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
    DropboxClientsManager.authorizeFromControllerV2(
      UIApplication.shared,
      controller: self,
      loadingStatusDelegate: nil,
      openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
      scopeRequest: scopeRequest
    )
  }
  
}
