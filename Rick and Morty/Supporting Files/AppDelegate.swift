//
//  AppDelegate.swift
//  Clear Project
//
//  Created by Дмитрий Хероим on 17.11.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = window else {
      assertionFailure("Please, choose launch storyboard")
      return false
    }
    
    AppCoordinator.shared.start(with: window)
    
    
    return true
  }
}

