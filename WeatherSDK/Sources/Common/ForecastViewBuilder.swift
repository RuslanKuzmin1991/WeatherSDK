//
//  ForecastViewBuilder.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 29.10.24.
//

import SwiftUI

internal final class ForecastViewBuilder {
    internal func buildWeatherView(forCityName cityName: String,
                   andApiKey key: String,
                   delegate: WeatherSDKDelegate?) -> some View {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = MainWeatherState(cityName: cityName,
                                     weatherService: weatherService)
        let rootView = MainWeatherView(navPath: NavigationPath(), state: state)
        return rootView
    }
    
    internal func buildDailyForecastView(forCityName cityName: String,
                                         andApiKey key: String,
                                         delegate: WeatherSDKDelegate?) -> some View {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = DailyForecastState(cityName: cityName,
                                       weatherService: weatherService)
        let rootView = DailyForecastView(state: state)
        return rootView
    }
    
    internal func buildWeeklyForecastView(forCityName cityName: String,
                   andApiKey key: String,
                   delegate: WeatherSDKDelegate?) -> some View {
        let weatherService = WeatherNetworkSerivce(key: key)
        let state = WeeklyForecastState(cityName: cityName,
                                        weatherService: weatherService)
        let rootView = WeeklyForecastView(state: state)
        return rootView
    }
}
