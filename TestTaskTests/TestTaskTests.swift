//
//  TestTaskTests.swift
//  TestTaskTests
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

import WeatherSDK
import XCTest
import SwiftUI
@testable import TestTask

class MockNavigationController: UINavigationController {
    var didPushViewController = false
    var didPresentViewController = false
    var didSetViewControllers = false
    var didPopViewController = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        didPushViewController = true
    }

    override func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        didPresentViewController = true
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        didSetViewControllers = true
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        return UIViewController()
    }
}

class MockWeatherSDKObj: WeatherSDKProtocol {
    func presentWeatherView(forCity cityName: String) -> AnyView {
        return AnyView(Text("city weather \(cityName)"))
    }
    
    func presentWeatherViewController(forCity city: String) -> UIViewController {
        return UIViewController()
    }
}
final class RouterAppTests: XCTestCase {

    var router: RouterApp!
    var mockNavigationController: MockNavigationController!
    var mockWeatherSDK: MockWeatherSDKObj!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        router = RouterApp()
        router.rootNavigator = mockNavigationController
        mockWeatherSDK = MockWeatherSDKObj()
        router.weatherSDK = mockWeatherSDK
    }

    override func tearDown() {
        router = nil
        mockNavigationController = nil
        mockWeatherSDK = nil
        super.tearDown()
    }

    func testRouterInitialization() {
        XCTAssertNotNil(router.rootNavigator, "Root navigator should be initialized")
        XCTAssertTrue(router.rootNavigator.viewControllers.isEmpty, "Initially, root navigator should have no view controllers")
    }

    func testSetRootView() {
        router.setRootView()
        XCTAssertNotNil(router.weatherSDK, "WeatherSDK should be initialized")
//        XCTAssertFalse(router.rootNavigator.viewControllers.isEmpty, "Root view controller should be set")
//        XCTAssertEqual(router.rootNavigator.viewControllers.first?.title, "main_screen_title".localized, "Root view controller's title should be set")
    }

    func testNavigateToWeatherScreenWithPush() {
        router.navigateToWeatherScreen(forCity: "Berlin", withNavigationType: .push, animated: true)

        XCTAssertEqual(router.currentNavigationType, .push, "Current navigation type should be push")
        XCTAssertTrue(mockNavigationController.didPushViewController, "pushViewController should be called")
    }

    func testNavigateToWeatherScreenWithPresent() {
        router.navigateToWeatherScreen(forCity: "Berlin", withNavigationType: .present, animated: true)

        XCTAssertEqual(router.currentNavigationType, .present, "Current navigation type should be present")
        XCTAssertTrue(mockNavigationController.didPresentViewController, "present should be called")
    }

    func testNavigateToWeatherScreenWithRebase() {
        router.navigateToWeatherScreen(forCity: "Berlin", withNavigationType: .rebase, animated: true)

        XCTAssertEqual(router.currentNavigationType, .rebase, "Current navigation type should be rebase")
        XCTAssertTrue(mockNavigationController.didSetViewControllers, "setViewControllers should be called")
    }

    func testOnFinished() {
        router.onFinished()

        XCTAssertTrue(mockNavigationController.didPresentViewController, "onFinished should present alert view")
    }

    func testOnFinishedWithError() {
        let error = NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        router.currentNavigationType = .push
        router.onFinishedWithError(error: error)

        XCTAssertEqual(router.currentNavigationType, .none, "Current navigation type should be none after error")
        XCTAssertTrue(mockNavigationController.didPopViewController, "popViewController should be called when error occurs during push navigation")
    }
}
