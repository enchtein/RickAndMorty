//
//  CharacterDTO.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

struct CharacterDTO: Codable {
  let info: InfoDTO
  let results: [ResultDTO]
}
