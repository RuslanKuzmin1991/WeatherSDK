//
//  NetworkModel.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 20.10.24.
//
// Want to add icon displaying in future
internal protocol WeatherProtocol {
    var code: Int { get }
    var icon: String { get }
    var description: String { get }
}

internal protocol CurrentWeatherDTOProtocol {
    var temperature: Double { get }
    var weather: Weather { get }
    var dateTime: String { get }
}

internal protocol WeatherResponseProtocol {
    var count: Int { get }
    var data: [CurrentWeatherDTO] { get }
}

internal protocol WeatherResponseHourProtocol {
    var data: [WeatherDTO] { get }
    var timezone: String { get }
}

internal protocol WeatherResponseDailyProtocol {
    var data: [WeatherDataDaily] { get }
    var timezone: String { get }
}

internal protocol WeatherDataDailyProtocol {
    var temp: Double? { get }
    var weather: Weather { get }
    var datetime: String { get }
}

internal protocol WeatherDTOProtocol {
    var temp: Double { get }
    var timestampUtc: String { get }
    var weather: Weather { get }
}

internal struct Weather: WeatherProtocol,
                         Codable {
    let code: Int
    let icon: String
    let description: String
}

internal struct CurrentWeatherDTO: CurrentWeatherDTOProtocol,
                                   Decodable {
    let temperature: Double
    let weather: Weather
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "temp"
        case dateTime = "ob_time"
    }
}

internal struct WeatherResponse: WeatherResponseProtocol,
                                 Decodable {
    let count: Int
    let data: [CurrentWeatherDTO]
}

internal struct WeatherResponseHour: WeatherResponseHourProtocol,
                                     Codable {
    let data: [WeatherDTO]
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case data
        case timezone
    }
}

internal struct WeatherResponseDaily: WeatherResponseDailyProtocol,
                                      Decodable {
    let data: [WeatherDataDaily]
    let timezone: String
}

internal struct WeatherDataDaily: WeatherDataDailyProtocol,
                         Decodable {
    let temp: Double?
    let weather: Weather
    let datetime: String
}

internal struct WeatherDTO: WeatherDTOProtocol,
                            Codable {
    let temp: Double
    let timestampUtc: String
    let weather: Weather

    enum CodingKeys: String, CodingKey {
        case temp
        case timestampUtc = "timestamp_utc"
        case weather
    }
}
