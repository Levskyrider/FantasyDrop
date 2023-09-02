//
//  BaseNavigationController.swift
//  FantasyDrop
//
//  Created by Dmitro Levkutnyk on 01.09.2023.
//

import UIKit

class BaseNavigationController: UINavigationController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    if let last = viewControllers.last {
      return last.preferredStatusBarStyle
    }
    return super.preferredStatusBarStyle
  }
  
  init(color: UIColor = .clear) {
    super.init(nibName: nil, bundle: nil)
    setup(color: color)
  }
  
  init(rootController: UIViewController, color: UIColor = .clear) {
    super.init(rootViewController: rootController)
    setup(color: color)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(color: UIColor) {
    navigationBar.prefersLargeTitles = false
    
    let appereance = UINavigationBarAppearance()
    appereance.configureWithOpaqueBackground()
    appereance.shadowColor = .clear
    
    let titleAttributes: [NSAttributedString.Key : Any] =
    [
      .foregroundColor : UIColor.black,
    ]
    
    appereance.titleTextAttributes = titleAttributes
    appereance.largeTitleTextAttributes = titleAttributes
    appereance.backgroundColor = color
    navigationBar.scrollEdgeAppearance = appereance
    navigationBar.standardAppearance = appereance
    navigationBar.compactAppearance = appereance
    
  }
  
}

extension BaseNavigationController {
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    setNeedsStatusBarAppearanceUpdate()
  }
  
}


