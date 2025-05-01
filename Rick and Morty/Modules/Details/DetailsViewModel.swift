//
//  DetailsViewModel.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

protocol DetailsViewModelDelegate: AnyObject {
  
}
final class DetailsViewModel {
  private var info: ResultDTO
  private weak var delegate: DetailsViewModelDelegate?
  
  init(info: ResultDTO, delegate: DetailsViewModelDelegate?) {
    self.info = info
    self.delegate = delegate
  }
  
  func viewDidLoad() {
    
  }
}
