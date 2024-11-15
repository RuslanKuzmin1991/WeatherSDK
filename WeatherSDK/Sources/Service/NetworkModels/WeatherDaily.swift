//
//  WeatherDaily.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 07.11.24.
//

internal protocol WeatherResponseDailyProtocol {
    associatedtype WeatherDataDailyType: WeatherDataDailyProtocol
    var data: [WeatherDataDailyType] { get }
    var timezone: String { get }
}

internal protocol WeatherDataDailyProtocol {
    associatedtype WeatherType: WeatherProtocol
    var temp: Double? { get }
    var weather: WeatherType { get }
    var datetime: String { get }
}

internal struct WeatherResponseDaily: WeatherResponseDailyProtocol,
                                      Decodable {
    typealias WeatherDataDailyType = WeatherDataDaily
    let data: [WeatherDataDailyType]
    let timezone: String
}

internal struct WeatherDataDaily: WeatherDataDailyProtocol,
                                  Decodable {
    typealias WeatherType = Weather
    let temp: Double?
    let weather: WeatherType
    let datetime: String
}
