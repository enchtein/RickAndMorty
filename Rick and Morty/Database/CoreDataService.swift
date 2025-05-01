//
//  CoreDataService.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import Foundation
import CoreData

final class CoreDataService {
  public static let shared = CoreDataService()
  
  private let model: String = "RickAndMorty"
  private let context: NSManagedObjectContext
  private let container: PersistentContainer
  
  private init() {
    self.container = PersistentContainer(name: model)
    self.context = container.viewContext
    container.loadPersistentStores() { [weak self] _, error in
      self?.container.viewContext.automaticallyMergesChangesFromParent = true
      if let err = error {
        fatalError("❌ Loading of store failed:\(err)")
      }
    }
  }
  
  func save(_ characterDTO: CharacterDTO, at page: Int) {
    CharacterDTOObject(context, for: characterDTO, page: page)
    container.saveContext(backgroundContext: context)
  }
  
  func fetch(page: Int) throws -> CharacterDTO? {
    let fetchRequest = NSFetchRequest<CharacterDTOObject>(entityName: "CharacterDTOObject")
    fetchRequest.predicate = NSPredicate(format: "page == %d", page)
    
    do {
      let entity = try context.fetch(fetchRequest)
      return entity.first?.toDTO
    } catch {
      throw error
    }
  }
}
