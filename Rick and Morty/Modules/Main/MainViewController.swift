//
//  MainViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 29.04.2025.
//

import UIKit
import Toast

final class MainViewController: BaseViewController {
  private lazy var cardTable = createCartTableView()
  private lazy var refreshControl = UIRefreshControl()
  
  private lazy var viewModel = MainViewModel(delegate: self)
  
  private var isToastShown = false
  
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
    cardTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.baseSideIndent).isActive = true
    cardTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    cardTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .zero).isActive = true
  }
  override func additionalUISettings() {
    refreshControl.attributedTitle = NSAttributedString(string: MainTitles.pullToRefresh.localized)
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    cardTable.addSubview(refreshControl) // not required when using UITableViewController
  }
  
  @objc func refresh(_ sender: UIRefreshControl) {
    // Code to refresh table view
    viewModel.reloadData()
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
    
    AppCoordinator.shared.push(.details(info))
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
  func showToast(for type: InfoProcessingToastType) {
    refreshControl.endRefreshing()
    
    guard !isToastShown else { return }
    let toast = Toast.default(image: nil, title: type.title, subtitle: type.subtitle)
    toast.delegate = self
    
    toast.show()
  }
  
  func dataSourceDidChange() {
    refreshControl.endRefreshing()
    cardTable.reloadData()
  }
}

//MARK: - ToastDelegate
extension MainViewController: ToastDelegate {
  func willShowToast(_ toast: Toast) {
    isToastShown = true
  }
  func didShowToast(_ toast: Toast) {
    debugPrint("didShowToast")
  }
  func willCloseToast(_ toast: Toast) {
    debugPrint("willCloseToast")
  }
  func didCloseToast(_ toast: Toast) {
    isToastShown = false
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings { }
