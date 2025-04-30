//
//  MainViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 29.04.2025.
//

import UIKit

class MainViewController: BaseViewController {
  private lazy var viewModel = MainViewModel(delegate: self)
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    viewModel.viewDidLoad()
  }
  
//  func addUIComponents() {}
//  
//  func setupColorTheme() {}
//  func setupFontTheme() {}
  override func setupLocalizeTitles() {
    title = MainTitles.title.localized
  }
//  func setupIcons() {}
//  
//  func setupConstraintsConstants() {}
//  func additionalUISettings() {}
}
//MARK: - UI elements creating
private extension MainViewController {
  
}
//MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
  func dataSourceDidChange() {
    print("dataSourceDidChange")
  }
}
