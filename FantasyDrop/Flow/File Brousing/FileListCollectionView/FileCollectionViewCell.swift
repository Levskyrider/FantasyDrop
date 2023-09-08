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
  
  //MARK: - Variables
  
  static var identrifier: String {
    String(describing: self)
  }
  
  var viewModel: FileCellViewModel? {
    didSet {
      bindViewModel()
      updateUIWith(viewModel: viewModel)
    }
  }
  
  //MARK: - UI
  
  var fileNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
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
  
  //MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(preetyContentView)
    preetyContentView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self).inset(15)
    }
    
    preetyContentView.addSubview(fileMiniatureImageView)
    fileMiniatureImageView.snp.makeConstraints { make in
      make.top.left.right.equalTo(preetyContentView).inset(15)
      make.bottom.equalTo(preetyContentView).inset(30)
    }
    
    preetyContentView.addSubview(fileNameLabel)
    fileNameLabel.snp.makeConstraints { make in
      make.top.equalTo(fileMiniatureImageView.snp.bottom).offset(3)
      make.left.right.equalTo(preetyContentView).inset(15)
      make.bottom.equalTo(preetyContentView).inset(3)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Bind
  
  func bindViewModel() {
    viewModel?.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .loadedImage(let image):
        if let image = image {
          self.fileMiniatureImageView.image = image
        }
      }
    }
  }
  
  //MARK: - UI Logic
  
  func updateUIWith(viewModel: FileCellViewModel?) {
    guard let viewModel = viewModel else { return }
    if let image = viewModel.imageMiniature {
      self.fileMiniatureImageView.image = image
    }
    self.fileNameLabel.text = viewModel.fileName
  }
  
}
