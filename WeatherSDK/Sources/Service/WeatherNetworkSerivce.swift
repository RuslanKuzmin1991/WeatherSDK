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
    private var key: String
    private var urlString: String = "https://api.weatherbit.io/v2.0"
    private let hoursForecast = "24"
    
    init(key: String) {
        self.key = key
    }
    
    func getCurrentWeather(forCity city: String) async throws -> CurrentWeatherDTO {
        guard var url = URL(string: urlString) else {
            throw ApiError.wrongUrl
        }
        url = url.appendingPathComponent(Endpoint.current.rawValue, conformingTo: .url)
        url = url.appending(queryItems: [
            URLQueryItem(name: ApiParamKeys.city.rawValue, value: city),
            URLQueryItem(name: ApiParamKeys.key.rawValue, value: key)
        ])
        
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
                
//                 Print for Debug
                            if let dataString = String(data: data, encoding: .utf8) {
                                print("data = \(dataString)")
                            }

                let decoder = JSONDecoder()
                do {
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    print(weatherResponse)
                    guard let dataModel = weatherResponse.data.first else {
                        throw ApiError.invalidResponse
                    }
                    return dataModel
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
    
    func getHourlyForecastWeather(forCity city: String) async throws -> [WeatherDTO] {
        guard var url = URL(string: "https://api.weatherbit.io/v2.0" ) else {
            throw ApiError.wrongUrl
        }
        url = url.appendingPathComponent(Endpoint.hourlyForecast.rawValue,
                                         conformingTo: .url)
        url = url.appending(queryItems: [
            URLQueryItem(name: ApiParamKeys.city.rawValue, value: city),
            URLQueryItem(name: ApiParamKeys.key.rawValue, value: key),
            URLQueryItem(name: ApiParamKeys.hours.rawValue, value: hoursForecast)
        ])
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
//                            if let dataString = String(data: data, encoding: .utf8) {
//                                print("data = \(dataString)")
//                            }
                
                do {
                    let weatherResponse = try parseWeatherData(from: data)
                    return weatherResponse.data
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
    
    func getWeeklyForecastWeather(forCity city: String) async throws -> [WeatherDataDaily] {
        guard var url = URL(string: urlString) else {
            throw ApiError.wrongUrl
        }
        url = url.appendingPathComponent(Endpoint.dailyForecast.rawValue, conformingTo: .url)
        url = url.appending(queryItems: [
            URLQueryItem(name: ApiParamKeys.city.rawValue, value: city),
            URLQueryItem(name: ApiParamKeys.key.rawValue, value: key),
            URLQueryItem(name: ApiParamKeys.days.rawValue, value: hoursForecast)
        ])
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
                    let weatherResponse = try decoder.decode(WeatherResponseDaily.self, from: data)
                    return weatherResponse.data
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
    
    private func parseWeatherData(from jsonData: Data) throws -> WeatherResponseHour {
        let decoder = JSONDecoder()
        do {
            let weatherResponse = try decoder.decode(WeatherResponseHour.self,
                                                     from: jsonData)
            return weatherResponse
        } catch {
            throw error
        }
    }
}
