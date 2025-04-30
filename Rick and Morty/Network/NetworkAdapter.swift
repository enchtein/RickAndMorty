//
//  NetworkAdapter.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

import Moya

struct NetworkAdapter {
  static private let provider: MoyaProvider<NetworkTarget> = {
    MoyaProvider<NetworkTarget>()
  }()
  
  static func getCharacter(for page: Int?) async throws -> CharacterDTO {
    try await provider.request(.getCharacter(page: page))
  }
}
