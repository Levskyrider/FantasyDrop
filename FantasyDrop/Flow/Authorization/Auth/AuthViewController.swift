//
//  AuthViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 03.09.2023.
//

import UIKit
import SwiftyDropbox

fileprivate enum Defaults {
  static let standardInset: CGFloat = 35
}

enum AuthViewControllerEvent {
  case loggedIn
}

class AuthViewController: UIViewController {
  
  //MARK: - Variables
  
  var onEvent: ((AuthViewControllerEvent) -> ())?
  var viewModel: AuthViewModel!
  
  //MARK: - UI
  
  private var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "default_background")
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "FantasyDrop"
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 35)
    return label
  }()
  
  private var authButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    button.setTitle("Start auth", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    button.clipsToBounds = true
    button.layer.cornerRadius = 15
    return button
  }()
  
  private let authSuccessViewSize = CGSize(width: 200, height: 80)
  
  private lazy var authSuccessView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    view.clipsToBounds = true
    view.layer.cornerRadius = 15
    let titleLabel = UILabel()
    titleLabel.text = "Authorisation\nsuccess!"
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.center.equalTo(view)
    }
    return view
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
  
  private func setupUI() {
    self.view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view)
    }
    
    self.view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self.view)
      make.top.equalTo(self.view.safeAreaLayoutGuide).inset(Defaults.standardInset)
    }
    
    self.view.addSubview(authButton)
    authButton.snp.makeConstraints { make in
      make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(Defaults.standardInset)
      make.height.equalTo(70)
    }
  }
  
  //MARK: - Bindings
  
  private func bind() {
    authButton.addTarget(self, action: #selector(startAuth), for: .touchUpInside)
  }
  
  //MARK: - UI logic
  
  @objc func startAuth() {
    viewModel.startDropboxAuth(controller: self)
  }
  
  func presentSuccessAuth() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
      self.authSuccessView.alpha = 0
      self.view.addSubview(self.authSuccessView)
      self.authSuccessView.snp.makeConstraints { make in
        make.center.equalTo(self.view)
        make.size.equalTo(self.authSuccessViewSize)
      }
      self.view.layoutIfNeeded()
      UIView.animate(withDuration: 0.5) {
        self.authSuccessView.alpha = 1
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      self.onEvent?(.loggedIn)
    }
  }

}

//MARK: - Handle Dropbox auth result

extension AuthViewController: AuthResultHandler {
  
  public func authSuccess() {
    presentSuccessAuth()
  }
  
  public func authCanceled() {
    authFailedAC(title: "Fail", message: "Auth canceled by user")
  }

  public func authError(description: String?) {
    authFailedAC(title: "Error", message: description ?? "Unknown error")
  }
  
  func authFailedAC(title: String, message: String?) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let tryAgain = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.startAuth()
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    ac.addAction(tryAgain)
    ac.addAction(cancel)
    self.present(ac, animated: true)
  }
  
}
