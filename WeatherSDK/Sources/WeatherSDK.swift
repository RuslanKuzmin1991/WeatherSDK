//
//  WeatherSDK.swift
//
//
//  Created by Ruslan Kuzmin on 19.10.24.
//

import Foundation
import UIKit
import SwiftUI

/// A protocol defining the core interface for presenting weather-related views in the WeatherSDK.
/// ///
/// Conforming types should implement methods to present weather information for a specified city
/// using either a UIKit `UIViewController` or a SwiftUI `AnyView`.
///
/// This protocol can be adopted by any class or struct that needs to present weather information
/// in both UIKit-based and SwiftUI-based applications.
public protocol WeatherSDKProtocol {
    /// Presents a weather view controller for a specific city
    func presentWeatherViewController(forCity cityName: String) -> UIViewController
    /// Presents a weather view controller for a specific city
    func presentWeatherView(forCity cityName: String) -> AnyView
}
/// A class representing the Weather SDK.
///
/// This class provides methods to present weather views in both
/// UIKit and SwiftUI applications.
///
/// - Parameters:
///   - apiKey: The API key for accessing weather data.
///   - delegate: The delegate to handle completion events.
///
public class WeatherSDKEntity: WeatherSDKProtocol {
    var key: String
    weak var delegate: WeatherSDKDelegate?
    
    /// Initializes the SDK with an API key and a delegate.
    public init(withApiKey apiKey: String,
         andDelegate delegate: WeatherSDKDelegate) {
        self.key = apiKey
        self.delegate = delegate
    }
    
    /// Sets the delegate for handling SDK events.
    public func setDelegate(delegate: WeatherSDKDelegate) {
        self.delegate = delegate
    }
    
    /// Presents a weather view controller for a specific city
    public func presentWeatherViewController(forCity cityName: String) -> UIViewController {
        let vc = ForecastScreenBuilder().buildWeatherScreen(forCityName: cityName,
                                                            andApiKey: key,
                                                            delegate: delegate)
        return vc
    }
    
    /// Presents a SwiftUI weather view for a specific city.
    public func presentWeatherView(forCity cityName: String) -> AnyView {
        let view = ForecastViewBuilder().buildWeatherView(forCityName: cityName,
                                                     andApiKey: key,
                                                     delegate: delegate)
        return view as! AnyView
    }
}


/// A protocol that defines methods to handle events for `WeatherSDKEntity`.
///
/// Implement this protocol to respond to completion or error events when working
/// with `WeatherSDKEntity`. The delegate provides feedback when weather data is
/// successfully loaded or when an error occurs.
public protocol WeatherSDKDelegate: AnyObject {
    
    /// Called when the weather data is successfully loaded.
    ///
    /// Use this method to perform any necessary actions after the weather data has been
    /// fetched and the corresponding view or data is ready.
    func onFinished()
    
    /// Called when there is an error during the weather data loading process.
       ///
       /// - Parameter error: The error that occurred while fetching the weather data.
       ///
       /// This method provides information about why the weather data loading failed.
       /// You can use this to show an error message to the user or handle the error appropriately.
    func onFinishedWithError(error: Error)
}
