//
//  MainViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 29.04.2025.
//

import UIKit

class MainViewController: BaseViewController {
  private lazy var cardTable = createCartTableView()
  private lazy var cardTableLeading = NSLayoutConstraint(item: cardTable, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: Constants.currentSideIndent)
  
  private lazy var viewModel = MainViewModel(delegate: self)
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    viewModel.viewDidLoad()
  }
  
  override func addUIComponents() {
    view.addSubview(cardTable)
  }
  override func setupColorTheme() {
    cardTable.backgroundColor = .clear
  }
  override func setupLocalizeTitles() {
    title = MainTitles.title.localized
  }
  override func setupConstraintsConstants() {
    cardTable.translatesAutoresizingMaskIntoConstraints = false
    cardTable.topAnchor.constraint(equalTo: view.topAnchor, constant: .zero).isActive = true
    
    cardTableLeading.constant = Constants.currentSideIndent
    cardTableLeading.isActive = true
    cardTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    cardTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .zero).isActive = true
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    cardTableLeading.constant = Constants.currentSideIndent
    cardTable.invalidateIntrinsicContentSize()
  }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as? CardTableViewCell {
      let info = viewModel.itemForCell(at: indexPath)
      cell.setupCell(with: info, delegate: self)
      
      return cell
    } else {
      return UITableViewCell()
    }
  }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    viewModel.runPaginationIfNeeded(for: indexPath)
  }
}

//MARK: - CardTableViewCellDelegate
extension MainViewController: CardTableViewCellDelegate {
  func didSelect(_ cell: CardTableViewCell) {
    guard let cellIndexPath = cardTable.indexPath(for: cell) else { return }
    let info = viewModel.itemForCell(at: cellIndexPath)
    print("didSelect \(info), GO TO NEXT VC")
  }
}

//MARK: - UI elements creating
private extension MainViewController {
  func createCartTableView() -> UITableView {
    let tableView = UITableView(frame: .zero)
    tableView.separatorStyle = .none
    
    tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.identifier)
    tableView.dataSource = self
    tableView.delegate = self
    
    return tableView
  }
}

//MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
  func dataSourceDidChange() {
    cardTable.reloadData()
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var minIndent: CGFloat { baseSideIndent }
  private static var safeArea: UIEdgeInsets {
    UIApplication.shared.appWindow?.safeAreaInsets ?? .zero
  }
  
  private static var currentMaxOrientationHIndent: CGFloat {
    let hMax = max(safeArea.left, safeArea.right)
    let vMax = max(safeArea.top, safeArea.bottom)
    return max(hMax, vMax)
  }
  static var currentSideIndent: CGFloat {
    let maxHIndent: CGFloat = currentMaxOrientationHIndent
    return UIDevice.current.orientation.isPortrait ? minIndent : max(minIndent, maxHIndent)
  }
}
