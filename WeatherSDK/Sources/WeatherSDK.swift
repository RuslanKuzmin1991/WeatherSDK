//
//  WeatherSDK.swift
//
//
//  Created by Ruslan Kuzmin on 19.10.24.
//

import Foundation
import UIKit
import SwiftUI

/// This file provides methods to present weather views in both
/// UIKit and SwiftUI applications.
///
/// Presents a weather view controller for a specific city
public func presentWeatherViewController(forCity cityName: String,
                                         withApiKey key: String,
                                         andDelegate delegate: WeatherSDKDelegate?) -> UIViewController {
    let vc = ForecastScreenBuilder().buildWeatherScreen(forCityName: cityName,
                                                        andApiKey: key,
                                                        delegate: delegate)
    return vc
}
    
/// Presents a SwiftUI weather view for a specific city.
public func presentWeatherView(forCity cityName: String,
                               withApiKey key: String,
                               andDelegate delegate: WeatherSDKDelegate?) -> AnyView {
    let view = ForecastViewBuilder().buildWeatherView(forCityName: cityName,
                                                     andApiKey: key,
                                                     delegate: delegate)
    return view as! AnyView
}


/// A protocol that defines methods to handle events for `WeatherSDKControllers`.
///
/// Implement this protocol to respond to completion or error events when working
/// with `WeatherSDKControllers`. The delegate provides feedback when weather data is
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
