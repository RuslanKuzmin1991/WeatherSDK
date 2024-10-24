//
//  Router.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//
import UIKit
import SwiftUI
import WeatherSDK


enum NavigationType {
    case push
    case present
    case rebase
}

protocol Router {
    func navigateToWeatherScreen(forCity city: String,
                                withNavigationType navigationType: NavigationType,
                                animated: Bool)
}

final class RouterApp: Router {
    var rootNavigator: UINavigationController
    var weatherSDK: WeatherSDKProtocol?
    var currentNavigationType: NavigationType?
    init() {
        rootNavigator = UINavigationController()
    }
    
    func setRootView() {
        setupSDK()
        let mainView = MainView(state: MainStateImpl(router: self, isEmbedded: true))
                        .environment(\.router, self)
        let hostingController = UIHostingController(rootView: mainView)
        hostingController.title = "main_screen_title".localized
        rootNavigator.setViewControllers([hostingController], animated: false)
        rootNavigator.navigationBar.tintColor = .control
    }
    
    func setupSDK() {
        weatherSDK = WeatherSDKEntity(withApiKey: API_KEY,
                                   andDelegate: self)
    }
    
    func navigateToWeatherScreen(forCity city: String,
                                withNavigationType navigationType: NavigationType = .push,
                                animated: Bool = false) {
        guard let viewController = weatherSDK?.presentWeatherViewController(forCity: city) else {
            return
        }
        handleNavigation(forViewController: viewController,
                         withNavigationType: navigationType,
                         animated: animated)
    }
    
    func navigateToWeatherView(forCity city: String) -> some View {
        self.rootNavigator.setNavigationBarHidden(true, animated: false)
        
        return weatherSDK?.presentWeatherView(forCity: city)
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
        self.rootNavigator.pushViewController(viewController,
                                              animated: animate)
    }
    
    private func present(viewController: UIViewController,
                 animate: Bool = false) {
        self.rootNavigator.present(viewController,
                                   animated: animate)
    }
    
    private func rebase(viewController: UIViewController,
                    animate: Bool = false) {
        self.rootNavigator.setViewControllers([viewController],
                                              animated: animate)
    }
}

extension RouterApp: WeatherSDKDelegate {
    func onFinished() {
        print("onFinish")
        let alert = UIAlertController(title: "main_screen_alert_title_success".localized,
                                      message: "main_screen_alert_body_success".localized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "main_screen_alert_dissmiss_button_title".localized,
                                      style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        self.present(viewController: alert)
    }
    
    func onFinishedWithError(error: any Error) {
        // Check if it was SwiftUI flow. In this case Alert should not be presented
        if currentNavigationType == nil {
            print(error.localizedDescription)
            return
        }
        switch currentNavigationType {
            case .present: self.rootNavigator.dismiss(animated: true)
            case .push: self.rootNavigator.popViewController(animated: true)
            case .rebase: print("rebased")
        case .none:
            print("none")
        }
        currentNavigationType = .none
        print("onFinishWithError")
        let alert = UIAlertController(title: "main_screen_alert_title_error".localized,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "main_screen_alert_dissmiss_button_title".localized,
                                      style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        
        self.present(viewController: alert)
    }
}
