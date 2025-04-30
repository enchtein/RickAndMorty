import UIKit

enum AppColor {
  static let backgroundOne = UIColor(resource: .backgroundOne)
  static let cardBg = UIColor(resource: .cardBg)
  
  static let mainText = UIColor(resource: .mainText)
  static let additionalText = UIColor(resource: .additionalText)
  
  enum Statuses {
    static let alive = UIColor(resource: .alive)
    static let dead = UIColor(resource: .dead)
    static let unknown = UIColor(resource: .unknown)
  }
}
