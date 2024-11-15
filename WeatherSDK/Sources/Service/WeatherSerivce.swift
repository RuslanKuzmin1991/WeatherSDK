//
//  WeatherSerivce.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//

protocol WeatherSerivce {
    associatedtype CurrentWeatherType: CurrentWeatherProtocol
    associatedtype WeatherDTOType: WeatherDTOProtocol
    associatedtype WeatherDataDailyType: WeatherDataDailyProtocol
    
    func getCurrentWeather(forCity city: String) async throws -> CurrentWeatherType
    func getHourlyForecastWeather(forCity city: String) async throws -> [WeatherDTOType]
    func getWeeklyForecastWeather(forCity city: String) async throws -> [WeatherDataDailyType]
}
