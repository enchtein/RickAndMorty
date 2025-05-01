//
//  InfoProcessingToastType.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 02.05.2025.
//

enum InfoProcessingToastType {
  case networkError
  case noDataInDB
  case dbError
  
  var title: String {
    switch self {
    case .networkError: MainTitles.networkError.localized
    case .noDataInDB: MainTitles.noDataInDB.localized
    case .dbError: MainTitles.dbError.localized
    }
  }
  var subtitle: String {
    switch self {
    case .networkError: MainTitles.networkErrorMsg.localized
    case .noDataInDB, .dbError: MainTitles.noDataInDBMsg.localized
    }
  }
}
