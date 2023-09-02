//
//  IntroViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 02.09.2023.
//

import UIKit

class IntroViewController: UIViewController {
  
  //MARK: - Variables
  
  var onLoaded: (() -> ())?
  
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
    label.font = UIFont.boldSystemFont(ofSize: 35)
    return label
  }()
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
   
    startStarndardAnimations { [weak self] in
      self?.onLoaded?()
    }
    
  }
  
  //MARK: - Setup UI
  
  func setupUI() {
    self.view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view)
    }
    
    self.view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.center.equalTo(self.view)
    }
    titleLabel.alpha = 0
  }
  
  //MARK: - Standsrd appearence
  
  func startStarndardAnimations(completion: (() -> Void)?) {
    UIView.animate(withDuration: 1.5) {
      self.titleLabel.alpha = 1
    } completion: { _ in
      completion?()
    }
  }
  
}
