//
//  WeatherSerivce.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//

protocol WeatherSerivce {
    func getCurrentWeather(forCity city: String) async throws -> CurrentWeatherDTO
    func getHourlyForecastWeather(forCity city: String) async throws -> [WeatherDTO]
    func getWeeklyForecastWeather(forCity city: String) async throws -> [WeatherDataDaily]
}
