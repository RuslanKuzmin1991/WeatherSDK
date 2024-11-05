//
//  RouterSDK.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 29.10.24.
//

import UIKit

enum NavigationType {
    case push
    case present
    case rebase
}

final class RouterSDK: RouterProtocol {
    func handleError(error: any Error) {
        
    }
    
    func handleSuccess() {
    }
    
    var rootNavigator: UINavigationController?
    var rootController: UIViewController
    var weatherSDK: WeatherSDKProtocol?
    var currentNavigationType: NavigationType?
    var apiKey: String = ""
    
    init(withVC vc: UIViewController,
         andApiKey apiKey: String) {
        rootController = vc
        self.apiKey = apiKey
    }
    
    func navigateToDailyForecast(forCity city: String,
                                 animated: Bool = false) {
        let vc = ForecastScreenBuilder().buildDalyForcastScreen(forCityName: city,
                                                                andApiKey: apiKey,
                                                                delegate: nil,
                                                                router: self)
        pushTo(viewController: vc,
               animated: animated)
        
    }
    
    func navigateToWeeklyForecast(forCity city: String,
                                  animated: Bool = false) {
        let vc = ForecastScreenBuilder().buildWeeklyForcastScreen(forCityName: city,
                                                                andApiKey: apiKey,
                                                                delegate: nil,
                                                                router: self)
        pushTo(viewController: vc,
               animated: animated)
    }
    
    private func handleNavigation(forViewController viewController: UIViewController,
                                  withNavigationType navigationType: NavigationType = .push,
                                  animated: Bool = false) {
        switch navigationType {
        case .present: self.present(viewController: viewController,
                                    animate: animated)
        case .push: self.push(viewController: viewController,
                                         animate: true)
        case .rebase: self.rebase(viewController: viewController,
                                  animate: true)
        }
        currentNavigationType = navigationType
    }
    
    private func push(viewController: UIViewController,
                    animate: Bool = false) {
        self.rootNavigator?.pushViewController(viewController,
                                              animated: animate)
    }
    
    private func present(viewController: UIViewController,
                 animate: Bool = false) {
        self.rootNavigator?.present(viewController,
                                   animated: animate)
    }
    
    private func rebase(viewController: UIViewController,
                    animate: Bool = false) {
        self.rootNavigator?.setViewControllers([viewController],
                                              animated: animate)
    }
    
    private func pushTo(viewController: UIViewController,
                        animated: Bool = false) {
        if let rootNav = rootNavigator {
            rootNav.pushViewController(viewController,
                                       animated: animated)
        } else if let rootNav = rootController.navigationController {
                self.rootNavigator = rootNav
                rootNav.pushViewController(viewController,
                                           animated: animated)
        } else {
            rootNavigator = UINavigationController(rootViewController: rootController)
            self.rootNavigator?.pushViewController(viewController,
                                                  animated: animated)
        }
    }
}

extension RouterSDK: WeatherSDKDelegate {
    func onFinished() {
    }
    
    func onFinishedWithError(error: any Error) {
    }
}
