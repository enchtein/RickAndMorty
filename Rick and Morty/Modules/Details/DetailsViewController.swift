//
//  DetailsViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import UIKit

final class DetailsViewController: BaseViewController {
  private let beginInfo: ResultDTO
  init(with info: ResultDTO) {
    self.beginInfo = info
    
    super.init(nibName: nil, bundle: nil)
  }
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var viewModel = DetailsViewModel(info: beginInfo, delegate: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
//  func addUIComponents() {}
//  
//  func setupColorTheme() {}
//  func setupFontTheme() {}
  override func setupLocalizeTitles() {
    title = DetailsTitles.title.localized
  }
//  func setupIcons() {}
//  
//  func setupConstraintsConstants() {}
//  func additionalUISettings() {}
}

//MARK: - DetailsViewModelDelegate
extension DetailsViewController: DetailsViewModelDelegate {
  
}

//MARK: - UI elements creating
private extension DetailsViewController {
  
}
