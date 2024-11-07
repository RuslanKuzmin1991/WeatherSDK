//
//  CurrentWeather.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 07.11.24.
//

internal protocol CurrentWeatherProtocol {
    associatedtype WeatherType: WeatherProtocol
    var temperature: Double { get }
    var weather: WeatherType { get }
    var dateTime: String { get }
}

internal protocol WeatherResponseProtocol {
    associatedtype CurrentWeatherType: CurrentWeatherProtocol
    var count: Int { get }
    var data: [CurrentWeatherType] { get }
}

internal struct WeatherResponse: WeatherResponseProtocol,
                                 Decodable {
    typealias CurrentWeatherType = CurrentWeatherDTO
    let count: Int
    let data: [CurrentWeatherType]
}

internal struct CurrentWeatherDTO: CurrentWeatherProtocol,
                                   Decodable {
    typealias WeatherType = Weather
    let temperature: Double
    let weather: Weather
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "temp"
        case dateTime = "ob_time"
    }
}
