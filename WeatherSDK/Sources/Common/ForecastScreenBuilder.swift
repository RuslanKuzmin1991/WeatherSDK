//
//  ForecastScreenBuilder.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//
import UIKit

protocol ScreenBuilderProtocol {
    func buildWeatherScreen(forCityName cityName: String,
                            andApiKey key: String,
                            delegate: WeatherSDKDelegate?) -> UIViewController
    func buildDalyForcastScreen(forCityName cityName: String,
                                andApiKey key: String,
                                delegate: WeatherSDKDelegate?) -> UIViewController
    func buildWeeklyForcastScreen(forCityName cityName: String,
                                  andApiKey key: String,
                                  delegate: WeatherSDKDelegate?) -> UIViewController
}

internal final class ForecastScreenBuilder: ScreenBuilderProtocol {
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
    
    internal func buildDalyForcastScreen(forCityName cityName: String,
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
    
    internal func buildWeeklyForcastScreen(forCityName cityName: String,
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
