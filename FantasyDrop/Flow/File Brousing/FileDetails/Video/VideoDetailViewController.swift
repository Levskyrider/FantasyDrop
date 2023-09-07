//
//  FileVideoDetailViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 05.09.2023.
//

import UIKit
import AVFoundation

class VideoDetailViewController: UIViewController {
  
  //MARK: - variables
  
  var viewModel: VideoDetailViewModel!
  var player: AVPlayer?
  
  //MARK: - UI
  
  var playerView = PlayerView()
  var contentView = UIView()
  var activityIndiccator = UIActivityIndicatorView()
  
  //MARK: - Init
  
  init(viewModel: VideoDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    
    viewModel.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .videoDownloaded:
        self.playVideo()
      case .startLoadingFile:
        print("Start loading")
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.view.addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view)
    }
    
    self.contentView.addSubview(playerView)
    playerView.translatesAutoresizingMaskIntoConstraints = false
    playerView.snp.makeConstraints { make in
      make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.contentView).inset(80)
    }
    playerView.playerLayer.videoGravity = .resizeAspect
    playerView.isHidden = true
    
    self.view.addSubview(activityIndiccator)
    activityIndiccator.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(playerView)
    }
    activityIndiccator.startAnimating()
    
    playVideo()
  }
  
  func playVideo() {
    guard let assetURL = viewModel.assetURL else { return }
    activityIndiccator.stopAnimating()
    activityIndiccator.isHidden = true
    let player = AVPlayer(url: assetURL)
    self.player = player
    playerView.playerLayer.player = self.player
    playerView.isHidden = false
    player.play()
  }
    
}
