//
//  Untitled.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 18.10.24.
//
import Foundation

enum ApiMethod: String {
    case get = "GET"
}

enum Endpoint: String {
    case current = "current"
    case hourlyForecast = "forecast/hourly"
    case dailyForecast = "forecast/daily"
}

enum ApiParamKeys: String {
    case city
    case key
    case hours
    case days
}

enum ApiError: Error {
    case wrongUrl
    case clientError(String)
    case parsingError(String)
    case networkError(String)
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(code: Int)
}

final internal class WeatherNetworkSerivce: WeatherSerivce {
    typealias CurrentWeatherType = CurrentWeatherDTO
    typealias WeatherDTOType = WeatherDTO
    typealias WeatherDataDailyType = WeatherDataDaily
    
    private var key: String
    private var urlString: String = "https://api.weatherbit.io/v2.0"
    private let hoursForecast = "24"
    
    init(key: String) {
        self.key = key
    }
    
    func getCurrentWeather(forCity city: String) async throws -> CurrentWeatherType {
        let params = [
            URLQueryItem(name: ApiParamKeys.city.rawValue, value: city),
            URLQueryItem(name: ApiParamKeys.key.rawValue, value: key)
        ]
        let weatherResponse: WeatherResponse = try await performRequest(endPoint: .current,
                                                                        params: params)//(urlRequest: request)
        guard let dataModel = weatherResponse.data.first else {
            throw ApiError.invalidResponse
        }
        return dataModel
    }
    
    func getHourlyForecastWeather(forCity city: String) async throws -> [WeatherDTOType] {
        let params = [
            URLQueryItem(name: ApiParamKeys.city.rawValue, value: city),
            URLQueryItem(name: ApiParamKeys.key.rawValue, value: key),
            URLQueryItem(name: ApiParamKeys.hours.rawValue, value: hoursForecast)
        ]
        let weatherResponse: WeatherResponseHour = try await performRequest(endPoint: .hourlyForecast,
                                                                            params: params)
        return weatherResponse.data
    }
    
    func getWeeklyForecastWeather(forCity city: String) async throws -> [WeatherDataDailyType] {
        let params = [
            URLQueryItem(name: ApiParamKeys.city.rawValue, value: city),
            URLQueryItem(name: ApiParamKeys.key.rawValue, value: key),
            URLQueryItem(name: ApiParamKeys.days.rawValue, value: hoursForecast)
        ]
        let weatherResponse: WeatherResponseDaily = try await performRequest(endPoint: .dailyForecast,
                                                                             params: params)
        return weatherResponse.data
    }
    
    private func performRequest<T: Decodable>(endPoint: Endpoint,
                                              params: [URLQueryItem]) async throws -> T {
        guard var url = URL(string: urlString) else {
            throw ApiError.wrongUrl
        }
        url = url.appendingPathComponent(endPoint.rawValue, conformingTo: .url)
        url = url.appending(queryItems: params)
        var request = URLRequest(url: url)
        request.httpMethod = ApiMethod.get.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            let statusCode = httpResponse.statusCode
            if statusCode >= 500 {
                throw ApiError.serverError(code: httpResponse.statusCode)
            }
            if statusCode >= 400 {
                throw ApiError.clientError("Client side error")
            }
            if statusCode >= 200 && statusCode < 300 {
                //                 Print for debugging
                if let dataString = String(data: data, encoding: .utf8) {
                    print("data = \(dataString)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(T.self, from: data)
                    return weatherResponse
                } catch {
                    throw ApiError.parsingError(error.localizedDescription)
                }
            } else {
                throw ApiError.invalidResponse
            }
        } catch {
            throw error
        }
    }
}
