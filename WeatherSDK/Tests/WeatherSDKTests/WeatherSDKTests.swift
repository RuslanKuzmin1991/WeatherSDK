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
    func testSDKInitialization() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let sdk = WeatherSDKEntity(withApiKey: "testApiKey", andDelegate: mockDelegate)
        XCTAssertEqual(sdk.key, "testApiKey", "API Key should match the provided value")
        XCTAssertNotNil(sdk.delegate, "Delegate should be set")
    }

    func testPresentWeatherViewController() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let sdk = WeatherSDKEntity(withApiKey: "testApiKey", andDelegate: mockDelegate)
        let viewController = sdk.presentWeatherViewController(forCity: "Munich")
        XCTAssertNotNil(viewController, "ViewController should be created for the given city")
    }

    func testPresentWeatherView() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let sdk = WeatherSDKEntity(withApiKey: "testApiKey", andDelegate: mockDelegate)
        let weatherView = sdk.presentWeatherView(forCity: "Berlin")
        XCTAssertNotNil(weatherView, "Weather SwiftUI View should be created for the given city")
    }

    func testDelegateOnFinished() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        _ = WeatherSDKEntity(withApiKey: "testApiKey", andDelegate: mockDelegate)
        mockDelegate.onFinished()
        XCTAssertTrue(mockDelegate.didFinish, "Delegate's onFinished should be called")
    }

    func testDelegateOnFinishedWithError() async throws {
        let mockDelegate = MockWeatherSDKDelegate()
        let _ = WeatherSDKEntity(withApiKey: "testApiKey", andDelegate: mockDelegate)
        
        let testError = NSError(domain: "com.weather.error", code: 404, userInfo: nil)
        mockDelegate.onFinishedWithError(error: testError)
        
        XCTAssertTrue(mockDelegate.didFinishWithError, "Delegate's onFinishedWithError should be called")
        XCTAssertEqual(mockDelegate.error?.localizedDescription, testError.localizedDescription, "Error should match the provided error")
    }
}
