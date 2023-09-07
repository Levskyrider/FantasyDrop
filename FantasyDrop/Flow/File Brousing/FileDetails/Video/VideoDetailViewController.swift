//
//  FileVideoDetailViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 05.09.2023.
//

import UIKit
import AVFoundation

class VideoDetailViewController: UITabBarController {
  
  var viewModel: VideoDetailViewModel!
  
  let player = AVPlayer(url: URL(fileURLWithPath: "path_to_your_video.mp4")) // Replace with your video URL or file path
    let playerLayer = AVPlayerLayer()
  
  init(viewModel: VideoDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    
    viewModel.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .videoDownloaded:
        self.playVideo()
        //self.setImage()
      case .startLoadingFile:
        print("Start loading")
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure the player layer
           playerLayer.player = player
           playerLayer.frame = view.bounds
           playerLayer.videoGravity = .resizeAspectFill
           view.layer.addSublayer(playerLayer)
           
           // Play the video
           
  }
  
  func playVideo() {
    guard let assetURL = viewModel.assetURL else { return }
    let player = AVPlayer(url: assetURL)
    playerLayer.player = player
    player.play()
  }
  
}
