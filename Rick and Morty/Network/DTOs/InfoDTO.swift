//
//  InfoDTO.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

struct InfoDTO: Codable {
  let count, pages: Int
  let next: String?
  let prev: String?
}
