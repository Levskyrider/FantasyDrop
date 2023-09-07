//
//  FileImageDetailViewController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 05.09.2023.
//

import UIKit

class ImageDetailViewController: UITabBarController, UIScrollViewDelegate {
  
  //MARK: - Variables
  
  var viewModel: ImageDetailViewModel!
  
  //MARK: - UI
  
  var scrollView: UIScrollView!
  var imageView: UIImageView!
  
  lazy var activityIndicator = UIActivityIndicatorView()
  
  //MARK: - Init
  
  init(viewModel: ImageDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    
    viewModel.onEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .startLoadingFile:
        self.startLoading()
      case .imageDownloaded:
        self.stopLoading()
        self.setImage()
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create UIScrollView
    scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 2.0
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    
    // Add constraints for UIScrollView
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    // Create UIImageView
    imageView = UIImageView(image: UIImage(named: ""))
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(imageView)
    
    // Add constraints for UIImageView
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
      imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])
    
    if let image = viewModel.image {
      imageView.image = image
    }
  }
  
  //MARK: - Logic
  
  func setImage() {
    self.imageView.image = viewModel.image
  }
  
  func startLoading() {
    self.view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.top.left.right.bottom.equalTo(self.view)
    }
    activityIndicator.startAnimating()
  }
  
  func stopLoading() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
  }
  
  // MARK: - UIScrollViewDelegate
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
}
