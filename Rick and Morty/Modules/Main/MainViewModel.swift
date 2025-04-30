//
//  MainViewModel.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
  func dataSourceDidChange()
}

@MainActor
final class MainViewModel {
  private weak var delegate: MainViewModelDelegate?
  
  private var info: [CharacterDTO] = []
  private var dataSource: [ResultDTO] = []
  
  init(delegate: MainViewModelDelegate?) {
    self.delegate = delegate
  }
  
  func viewDidLoad() {
    fetchInfo()
  }
}
//MARK: - API (DataSource)
extension MainViewModel {
  func runPaginationIfNeeded() {
    let nextPagePath = info.last?.info.next
    guard let nextPagePath else { return }
    
    let components = URLComponents(string: nextPagePath)
    let pageItem = components?.queryItems?.first { $0.name.elementsEqual("page") }
    
    guard let pageNumberStr = pageItem?.value, let pageNumber = Int(pageNumberStr) else { return }
    fetchInfo(for: pageNumber)
  }
}
//MARK: - Helpers (DataSource)
private extension MainViewModel {
  func updateInfoAndDataSource(with newInfo: CharacterDTO) {
    info.append(newInfo)
    
    let newDataSource = info.map { $0.results }.reduce([], +)
    dataSource = newDataSource
    
    delegate?.dataSourceDidChange()
    
    runPaginationIfNeeded()//TEMP
  }
}
//MARK: - Network layer
private extension MainViewModel {
  func fetchInfo(for page: Int? = nil) {
    Task {
      do {
        let info = try await NetworkAdapter.getCharacter(for: page)
        updateInfoAndDataSource(with: info)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
