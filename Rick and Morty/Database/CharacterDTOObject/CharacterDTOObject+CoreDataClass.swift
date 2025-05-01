//
//  CharacterDTOObject+CoreDataClass.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import Foundation
import CoreData

@objc(CharacterDTOObject)
final public class CharacterDTOObject: NSManagedObject {
  typealias Response = CharacterDTO
}

extension CharacterDTOObject: ObjectFactory {
  @discardableResult
  convenience init(_ context: Context, for content: Response, page: Int) {
    self.init(context, for: content)
    
    self.page = Int64(page)
  }
  
  @discardableResult
  convenience init(_ context: Context, for content: Response) {
    self.init(context: context)
    
    self.page = Int64(0)
    self.info = try! JSONEncoder().encode(content.info)
    
    self.results = content.results.compactMap { try? JSONEncoder().encode($0) }
  }
  
  var toDTO: CharacterDTO {
    let info = try! JSONDecoder().decode(InfoDTO.self, from: info)
    
    let results = results.compactMap {
      try? JSONDecoder().decode(ResultDTO.self, from: $0)
    }
    
    return CharacterDTO.init(info: info, results: results)
  }
}
