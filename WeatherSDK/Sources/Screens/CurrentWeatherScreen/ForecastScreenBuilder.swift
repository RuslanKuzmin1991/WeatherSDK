//
//  ForecastScreenBuilder.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//
import UIKit
import SwiftUI

internal final class ForecastScreenBuilder {
    internal func buildWeatherView(forCityName cityName: String,
                   andApiKey key: String,
                   delegate: WeatherSDKDelegate?) -> some View {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = MainWeatherState(cityName: cityName,
                                  weatherService: weatherService)
        state.delegate = delegate
        let rootView = MainWeatherView(state: state)
        return rootView
    }
    
    internal func buildWeatherScreen(forCityName cityName: String,
                            andApiKey key: String,
                            delegate: WeatherSDKDelegate?) -> UIViewController {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = MainWeatherState(cityName: cityName,
                                      weatherService: weatherService,
                                      isEmbedded: true)
        state.delegate = delegate
        let rootView = MainWeatherView(state: state)
        let vc = SwiftUIViewController(cityName: cityName,
                                       rootView: rootView)
        vc.delegate = delegate
        vc.title = "navigation_title".localized
        return vc
    }
}
