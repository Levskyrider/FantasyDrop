//
//  PlayerView.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 07.09.2023.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
  
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
}
