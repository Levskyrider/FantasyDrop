//
//  FileCollectionViewCell.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 04.09.2023.
//

import UIKit

fileprivate enum Defaults {
  static let docImageName = "doc.on.doc.fill"
  static let imagePlaceholder = "photo.fill"
  static let videoPlaceholder = "video.square.fill"
}

class FileCollectionViewCell: UICollectionViewCell {
  
  static var identrifier: String {
    String(describing: self)
  }
  
  var viewModel: FileCellViewModel? {
    didSet {
      bindViewModel()
      updateUIWith(viewModel: viewModel)
    }
  }
  
  var fileMiniatureImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: Defaults.docImageName)?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  var preetyContentView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    view.clipsToBounds = true
    view.layer.cornerRadius = 15
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(preetyContentView)
    preetyContentView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self).inset(15)
    }
    
    preetyContentView.addSubview(fileMiniatureImageView)
    fileMiniatureImageView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(preetyContentView).inset(15)
    }
    
  }
  
  func bindViewModel() {
    viewModel?.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .loadedImage(let image):
        if let image = image {
          self.fileMiniatureImageView.image = image
        }
      case .shouldOpen(let fileType, let path):
        print("Should open")
      }
    }
  }
  
  func updateUIWith(viewModel: FileCellViewModel?) {
    guard let viewModel = viewModel else { return }
    if let image = viewModel.imageMiniature {
      self.fileMiniatureImageView.image = image
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
