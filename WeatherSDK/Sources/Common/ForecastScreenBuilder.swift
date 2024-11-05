//
//  ForecastScreenBuilder.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//
import UIKit
import SwiftUI

protocol ScreenBuilderProtocol {
    func buildWeatherScreen(forCityName cityName: String,
                            andApiKey key: String,
                            delegate: WeatherSDKDelegate?) -> UIViewController
    
    func buildDalyForcastScreen(forCityName cityName: String,
                                andApiKey key: String,
                                delegate: WeatherSDKDelegate?,
                                router: RouterProtocol) -> UIViewController
    
    func buildWeeklyForcastScreen(forCityName cityName: String,
                                  andApiKey key: String,
                                  delegate: WeatherSDKDelegate?,
                                  router: RouterProtocol) -> UIViewController
}

internal final class ForecastScreenBuilder: ScreenBuilderProtocol {
    internal func buildWeatherScreen(forCityName cityName: String,
                            andApiKey key: String,
                            delegate: WeatherSDKDelegate?) -> UIViewController {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = MainWeatherState(cityName: cityName,
                                     weatherService: weatherService,
                                     isEmbedded: true)
        let rootView = MainWeatherView(navPath: NavigationPath(), state: state)
        let vc = SwiftUIViewController(cityName: cityName,
                                       rootView: rootView)
        vc.delegate = delegate
        vc.title = (String(format: "navigation_title".localized, cityName))
        let router = RouterSDK(withVC: vc,
                               andApiKey: key)
        state.router = router
        return vc
    }
    
    internal func buildDalyForcastScreen(forCityName cityName: String,
                            andApiKey key: String,
                            delegate: WeatherSDKDelegate?,
                            router: RouterProtocol) -> UIViewController {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = DailyForecastState(cityName: cityName,
                                       weatherService: weatherService,
                                       isEmbedded: true)
        state.router = router
        let rootView = DailyForecastView(state: state)
        let vc = SwiftUIViewController(cityName: cityName,
                                       rootView: rootView)
        vc.delegate = delegate
        vc.title = (String(format: "daily_forecast_navigation_title".localized, cityName))
        return vc
    }
    
    internal func buildWeeklyForcastScreen(forCityName cityName: String,
                            andApiKey key: String,
                            delegate: WeatherSDKDelegate?,
                            router: RouterProtocol) -> UIViewController {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = WeeklyForecastState(isEmbedded: true,
                                        cityName: cityName,
                                        weatherService: weatherService)
        state.router = router
        let rootView = WeeklyForecastView(state: state)
        let vc = SwiftUIViewController(cityName: cityName,
                                       rootView: rootView)
        vc.delegate = delegate
        vc.title = (String(format: "weekly_forecast_navigation_title".localized, cityName))
        return vc
    }

}
