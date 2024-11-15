//
//  DailyForecastState.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 24.10.24.
//
import SwiftUI

protocol DailyForecastStateProtocol: BasicStateProtocol, ObservableObject {
    var shouldGoBack: Bool { get set }
    var data: [WeatherUIDataProtocol] { get set }
    var weatherService: any WeatherSerivce { get }
    func updateData() async
}

final internal class DailyForecastState: DailyForecastStateProtocol {
    var router: (any RouterProtocol)?
    var isEmbedded: Bool = false
    var error: Error?
    @Published var cityName: String = ""
    @Published var data: [WeatherUIDataProtocol] = []
    
                                            /*[WeatherUIData(),
                                               WeatherUIData(),
                                               WeatherUIData()]*/ //For Preview
    @Published var isLoading = false
    @Published var shouldGoBack = false
    //For preview
//      self.currentWeatherData =  WeatherUIData(weatherDTO: CurrentWeatherDTO(temperature: 14, weather: Weather(description: "Clear sky"), dateTime: "20"), cityName: "Munich")
    
    let weatherService: any WeatherSerivce

    
    init(cityName: String,
         weatherService: any WeatherSerivce,
         isEmbedded: Bool = false) {
        self.cityName = cityName
        self.weatherService = weatherService
        self.isEmbedded = isEmbedded
    }
    
    deinit {
        print("Deinit \(String(describing: Self.self))")
    }
  
    @MainActor
    func updateData() async {
        self.isLoading = true
        await self.getHourForecastData()
        self.isLoading = false
    }
    
    @MainActor
    private func getHourForecastData() async {
        do {
            let weatherResponseDataArr = try await weatherService.getHourlyForecastWeather(forCity: cityName)
            data = []
            weatherResponseDataArr.forEach { weather in
                let weatherHourUI = WeatherUIData(weatherDTO: weather)
                data.append(weatherHourUI)
            }
        } catch {
            router?.handleError(error: error)
        }
    }
}
