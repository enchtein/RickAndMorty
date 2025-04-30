//
//  AppFont.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

import UIKit

enum FontType {
  case light
  case regular
  case medium
  case bold
  
  fileprivate var type: String {
    switch self {
    case .light: "Helvetica Neue Light" //300
    case .regular: "Helvetica Neue Regular" //400
    case .medium: "Helvetica Neue Medium" //500
    case .bold: "Helvetica Neue Bold" //700
    }
  }
}

struct AppFont {
  static func font(type: FontType, size: CGFloat) -> UIFont {
    UIFont(name: type.type, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
  }
  static func font(type: FontType, size: Int) -> UIFont {
    font(type: type, size: CGFloat(size))
  }
}
