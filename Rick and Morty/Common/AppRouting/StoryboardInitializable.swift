//import UIKit
//
//protocol StoryboardInitializable {
//  static var storyboardName: String { get }
//  static var storyboardBundle: Bundle? { get }
//  
//  static func createFromStoryboard() -> Self
//}
//
//extension StoryboardInitializable where Self : UIViewController {
//  static var storyboardName: String {
//    return "LaunchScreen"
//  }
//  
//  static var storyboardBundle: Bundle? {
//    return nil
//  }
//  
//  static var storyboardIdentifier: String {
//    return String(describing: self)
//  }
//  
//  static func createFromStoryboard() -> Self {
//    let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
//    return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
//  }
//}
//
////extension StoryboardInitializable where Self : SplashScreenViewController {
////  static var storyboardName: String {
////    return "SplashScreen"
////  }
////}
////extension StoryboardInitializable where Self : OnBoardingViewController {
////  static var storyboardName: String {
////    return "OnBoarding"
////  }
////}
