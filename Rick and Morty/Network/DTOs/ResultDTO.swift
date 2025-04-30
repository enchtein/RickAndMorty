//
//  ResultDTO.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

struct ResultDTO: Codable {
  let id: Int
  let name: String
  let status: StatusDTO
  let species: String?
  let type: String
  let gender: GenderDTO
  let origin, location: LocationDTO
  let image: String
  let episode: [String]
  let url: String
  let created: String
}
