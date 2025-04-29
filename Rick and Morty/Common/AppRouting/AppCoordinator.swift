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
  func showWelcome(isPrepairNeeded: Bool = true) {
    guard let currentNavigator else { fatalError("currentNavigator - is not initilized") }
    
    if isPrepairNeeded {
      prepair(currentNavigator)
    }
    
    currentNavigator.setViewControllers([instantiate(.onBoarding)], animated: true)
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

//MARK: - Helpers
extension AppCoordinator {
  private func instantiate(_ controller: AppViewController) -> UIViewController {
    switch controller {
//    case .splashScreen:
//      return SplashScreenViewController.createFromStoryboard()
//    case .onBoarding:
//      return OnBoardingViewController.createFromStoryboard()
    default:
      let vc = UIViewController()
      vc.view.backgroundColor = .green
      return vc
    }
  }
  private func prepair(_ navVC: UINavigationController) {
    navVC.popToRootViewController(animated: true)
    navVC.setNavigationBarHidden(true, animated: true)
  }
}
