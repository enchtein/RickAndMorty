//
//  MainViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 29.04.2025.
//

import UIKit

class MainViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    Task {
      do {
        let res = try await NetworkAdapter.getCharacter(for: nil)
        print("test")
      } catch {
        print(error.localizedDescription)
      }
    }
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
