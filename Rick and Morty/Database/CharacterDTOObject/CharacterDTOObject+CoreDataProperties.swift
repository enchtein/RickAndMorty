//
//  CharacterDTOObject+CoreDataProperties.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import Foundation
import CoreData


extension CharacterDTOObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterDTOObject> {
        return NSFetchRequest<CharacterDTOObject>(entityName: "CharacterDTOObject")
    }

  @NSManaged public var page: Int64
  @NSManaged public var info: Data
  @NSManaged public var results: [Data]
}
