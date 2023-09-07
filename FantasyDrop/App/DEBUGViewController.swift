//
//  DEBUGViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 05.09.2023.
//

import UIKit

class DEBUGViewController: UITabBarController {
  
  private var collectionView: UICollectionView!

  private var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "doc.on.doc")
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "DEBUG"
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupCollectionView()
    setupUI()
    
  }
  
  func setupUI() {
    self.view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
//    self.view.addSubview(imageView)
  }
  
  func setupCollectionView() {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    let squareItemSize = self.view.bounds.width / 2
    layout.itemSize = CGSize(width: squareItemSize, height: squareItemSize)
    
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: FileCollectionViewCell.identrifier)
  }
  
}

extension DEBUGViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.identrifier, for: indexPath) as! FileCollectionViewCell
    
    return cell
  }
  
  
}
