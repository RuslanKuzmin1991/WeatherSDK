//
//  WeatherHour.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 07.11.24.
//

internal protocol WeatherResponseHourProtocol {
    associatedtype WeatherType: WeatherDTOProtocol
    var data: [WeatherType] { get }
    var timezone: String { get }
}

internal struct WeatherResponseHour: WeatherResponseHourProtocol,
                                     Codable {
    typealias WeatherType = WeatherDTO
    let data: [WeatherType]
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case data
        case timezone
    }
}
