//
//  WeatherSDKTests.swift
//  WeatherSDKTests
//
//  Created by Ruslan Kuzmin on 19.10.24.
//

import XCTest
@testable import WeatherSDK

class MockWeatherSDKDelegate: WeatherSDKDelegate {
    var didFinish = false
    var didFinishWithError = false
    var error: Error?

    func onFinished() {
        didFinish = true
    }

    func onFinishedWithError(error: Error) {
        didFinishWithError = true
        self.error = error
    }
}

final class WeatherSDKTests: XCTestCase {
    func testPresentWeatherViewController() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let viewController = presentWeatherViewController(forCity: "Munich",
                                                          withApiKey: "testApiKey",
                                                          andDelegate: mockDelegate)
        XCTAssertNotNil(viewController, "ViewController should be created for the given city")
    }

    func testPresentWeatherView() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let weatherView = presentWeatherView(forCity: "Berlin",
                                             withApiKey: "testApiKey",
                                             andDelegate: mockDelegate)
        XCTAssertNotNil(weatherView, "Weather SwiftUI View should be created for the given city")
    }

    func testDelegateOnFinished() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        mockDelegate.onFinished()
        XCTAssertTrue(mockDelegate.didFinish, "Delegate's onFinished should be called")
    }

    func testDelegateOnFinishedWithError() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let testError = NSError(domain: "com.weather.error", code: 404, userInfo: nil)
        mockDelegate.onFinishedWithError(error: testError)
        
        XCTAssertTrue(mockDelegate.didFinishWithError, "Delegate's onFinishedWithError should be called")
        XCTAssertEqual(mockDelegate.error?.localizedDescription, testError.localizedDescription, "Error should match the provided error")
    }
}
