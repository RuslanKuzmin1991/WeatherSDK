//
//  NetworkModel.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 20.10.24.
//
// Want to add icon displaying in future
internal struct Weather: Codable {
    let code: Int
    let icon: String
    let description: String
}

internal struct CurrentWeatherDTO: Decodable {
    let temperature: Double
    let weather: Weather
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "temp"
        case dateTime = "ob_time"
    }
}

internal struct WeatherResponse: Decodable {
    let count: Int
    let data: [CurrentWeatherDTO]
}

internal struct WeatherResponseHour: Codable {
    let data: [WeatherDTO]
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case data
        case timezone
    }
}

internal struct WeatherDTO: Codable {
    let temp: Double
    let timestampUtc: String
    let weather: Weather

    enum CodingKeys: String, CodingKey {
        case temp
        case timestampUtc = "timestamp_utc"
        case weather
    }
}
