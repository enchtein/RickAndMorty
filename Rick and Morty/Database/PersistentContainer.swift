//
//  PersistentContainer.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {
  typealias Context = NSManagedObjectContext
  
  func saveContext(backgroundContext: Context? = nil) {
    let context = backgroundContext ?? viewContext
    guard context.hasChanges else { return }
    do {
      try context.save()
    } catch let error as NSError {
      debugPrint(error, error.userInfo)
    }
  }
}
