import UIKit

final class AppCoordinator: NSObject {
  static let shared = AppCoordinator()
  var currentNavigator: UINavigationController?
  
  private override init() { }
  
  func start(with window: UIWindow, completion: @escaping (() -> Void) = {}) {
    completion()
    
    let splashScreenViewController = self.instantiate(.splashScreen)
    currentNavigator = UINavigationController(rootViewController: splashScreenViewController)
    
    currentNavigator?.setNavigationBarHidden(true, animated: true)
    window.rootViewController = currentNavigator
    window.makeKeyAndVisible()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.activateRoot()
    }
  }
  
  func activateRoot() {
    guard let currentNavigator else { fatalError("currentNavigator - is not initilized") }
    prepair(currentNavigator)
    currentNavigator.setViewControllers([instantiate(.main)], animated: true)
  }
  
  func push(_ controller: AppViewController, animated: Bool = true) {
    let vc = instantiate(controller)
    currentNavigator?.pushViewController(vc, animated: animated)
  }
  func present(_ controller: AppViewController, animated: Bool) {
    let presentingVC = UIApplication.topViewController()
    let vc = instantiate(controller)
    
    presentingVC?.present(vc, animated: animated, completion: nil)
  }
  
  func child(before vc: UIViewController) -> UIViewController? {
    let viewControllers = currentNavigator?.viewControllers ?? []
    
    guard let currentVCIndex = viewControllers.firstIndex(of: vc) else { return nil }
    let prevIndex = viewControllers.index(before: currentVCIndex)
    
    guard viewControllers.indices.contains(prevIndex) else { return nil }
    return viewControllers[prevIndex]
  }
}

//MARK: - UI Helpers
private extension AppCoordinator {
  func setupNavigationControllerAppearance() {
    guard let currentNavigator else { return }
    currentNavigator.setNavigationBarHidden(false, animated: false)
    
    // Navigation Bar background color
    let appearance = UINavigationBarAppearance()
    
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = .clear
    appearance.shadowImage = UIImage()
    
    appearance.backgroundColor = Constants.bgColor
    
    // setup title font color
    let titleAttribute = [NSAttributedString.Key.font: Constants.font, NSAttributedString.Key.foregroundColor: Constants.fontColor]
    appearance.titleTextAttributes = titleAttribute
    
    currentNavigator.navigationBar.standardAppearance = appearance
    currentNavigator.navigationBar.scrollEdgeAppearance = appearance
  }
}
//MARK: - Helpers
extension AppCoordinator {
  private func instantiate(_ controller: AppViewController) -> UIViewController {
    switch controller {
//    case .splashScreen:
//      return SplashScreenViewController.createFromStoryboard()
//    case .onBoarding:
//      return OnBoardingViewController.createFromStoryboard()
    case .main:
      return MainViewController()
    default:
      let vc = UIViewController()
      vc.view.backgroundColor = .green
      return vc
    }
  }
  private func prepair(_ navVC: UINavigationController) {
    navVC.popToRootViewController(animated: true)
    setupNavigationControllerAppearance()
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static let bgColor = AppColor.cardBg
  static let fontColor = AppColor.mainText
  
  static var font: UIFont {
    let fontSize = sizeProportion(for: 25.0, minSize: 20.0)
    return AppFont.font(type: .bold, size: fontSize)
  }
}
