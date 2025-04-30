//
//  NetworkTarget.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

import Foundation
import Moya

enum NetworkTarget {
  case getCharacter(page: Int?)
}
extension NetworkTarget: TargetType {
  var actionName: String {
    switch self {
    case .getCharacter: "character"
    }
  }
  var baseURL: URL {
    URL(string: "https://rickandmortyapi.com")!
  }
  
  var path: String {
    switch self {
    case .getCharacter: "api/" + actionName
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getCharacter: .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getCharacter(let page):
      var urlParams = [String: Any]()
      
      if let page {
        urlParams["page"] = page
      }
      
      return .requestParameters(parameters: urlParams, encoding: URLEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    var dictionary = [String: String]()
    dictionary["Content-Type"] = "application/json"
    
    return dictionary
  }
}
