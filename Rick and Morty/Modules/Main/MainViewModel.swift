//
//  MainViewModel.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
  func dataSourceDidChange()
  func showToast(for type: InfoProcessingToastType)
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
  
  func reloadData() {
    info.removeAll()
    dataSource.removeAll()
    
    fetchInfo()
  }
}

//MARK: - API (DataSource)
extension MainViewModel {
  func runPaginationIfNeeded(for indexPath: IndexPath) {
    let index = itemIndex(from: indexPath)
    let flagIndex = dataSource.index(index, offsetBy: 5)
    guard dataSource.count < flagIndex else { return }
    
    let nextPagePath = info.last?.info.next
    guard let nextPagePath else { return }
    
    let components = URLComponents(string: nextPagePath)
    let pageItem = components?.queryItems?.first { $0.name.elementsEqual("page") }
    
    guard let pageNumberStr = pageItem?.value, let pageNumber = Int(pageNumberStr) else { return }
    fetchInfo(for: pageNumber)
  }
  
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    dataSource.count
  }
  func itemForCell(at indexPath: IndexPath) -> ResultDTO {
    let index = itemIndex(from: indexPath)
    return dataSource[index]
  }
}

//MARK: - Helpers (DataSource)
private extension MainViewModel {
  func updateInfoAndDataSource(with newInfo: CharacterDTO) {
    info.append(newInfo)
    
    let newDataSource = info.map { $0.results }.reduce([], +)
    dataSource = newDataSource
    
    delegate?.dataSourceDidChange()
  }
  
  func itemIndex(from indexPath: IndexPath) -> Int {
    indexPath.row
  }
}

//MARK: - Network layer
private extension MainViewModel {
  func fetchInfo(for page: Int? = nil) {
    Task {
      do {
        let info = try await NetworkAdapter.getCharacter(for: page)
        saveToDB(info, for: page)
        
        updateInfoAndDataSource(with: info)
      } catch {
        debugPrint("can`t fetch CharacterDTO from server \(error)")
        fetchDBInfo(for: page)
      }
    }
  }
}
//MARK: - CoreData layer
private extension MainViewModel {
  func saveToDB(_ character: CharacterDTO, for page: Int?) {
    Task {
      CoreDataService.shared.save(character, at: page ?? 0)
    }
  }
  func fetchDBInfo(for page: Int?) {
    Task {
      do {
        let character = try CoreDataService.shared.fetch(page: page ?? 0)
        if let character {
          updateInfoAndDataSource(with: character)
          delegate?.showToast(for: .networkError)
        } else {
          delegate?.showToast(for: .noDataInDB)
        }
      } catch {
        debugPrint("can`t fetch CharacterDTOObject from db \(error)")
        delegate?.showToast(for: .dbError)
      }
    }
  }
}
