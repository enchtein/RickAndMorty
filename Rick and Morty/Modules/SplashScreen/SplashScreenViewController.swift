//
//  SplashScreenViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 02.05.2025.
//

import UIKit
import Lottie

class SplashScreenViewController: BaseViewController {
  private lazy var animationView: LottieAnimationView = createAnimationView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func addUIComponents() {
    view.addSubview(animationView)
  }
  override func setupConstraintsConstants() {
    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
    animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor).isActive = true
    animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  override func additionalUISettings() {
    animationView.cornerRadius = Constants.baseSideIndent
    animationView.play()
  }
}

//MARK: - UI elemetns creating
private extension SplashScreenViewController {
  func createAnimationView() -> LottieAnimationView {
    let animationView = LottieAnimationView(name: "AppLoading")
    animationView.loopMode = .loop
    
    return animationView
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings { }
