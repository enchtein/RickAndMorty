//
//  ObjectFactory.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import Foundation
import CoreData

protocol ObjectFactory {
  typealias Context = NSManagedObjectContext
  associatedtype Response: Codable
  @discardableResult
  init(_ context: Context, for content: Response)
}
