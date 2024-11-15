//
//  Weather.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 07.11.24.
//

internal protocol WeatherProtocol {
    var code: Int { get }
    var icon: String { get }
    var description: String { get }
}

internal protocol WeatherDTOProtocol {
    associatedtype WeatherType: WeatherProtocol
    var temp: Double { get }
    var timestampUtc: String { get }
    var weather: WeatherType { get }
}

internal struct Weather: WeatherProtocol,
                         Codable {
    let code: Int
    let icon: String
    let description: String
}

internal struct WeatherDTO: WeatherDTOProtocol,
                            Codable {
    typealias WeatherType = Weather
    let temp: Double
    let timestampUtc: String
    let weather: WeatherType

    enum CodingKeys: String, CodingKey {
        case temp
        case timestampUtc = "timestamp_utc"
        case weather
    }
}
