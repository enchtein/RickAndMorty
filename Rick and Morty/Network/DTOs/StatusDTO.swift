//
//  StatusDTO.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//
import UIKit

enum StatusDTO: String, Codable {
  case alive = "Alive"
  case dead = "Dead"
  case unknown = "unknown"
  
  var color: UIColor {
    switch self {
    case .alive: AppColor.Statuses.alive
    case .dead: AppColor.Statuses.dead
    case .unknown: AppColor.Statuses.unknown
    }
  }
}
