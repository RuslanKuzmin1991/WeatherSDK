//
//  Untitled.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 29.10.24.
//

protocol WeeklyForecastStateProtocol: BasicStateProtocol,
                                      ObservableObject {
    var data: [WeatherUIDataProtocol] { get set }
    var shouldGoBack: Bool { get set }
}

final class WeeklyForecastState: WeeklyForecastStateProtocol {
    var router: (any RouterProtocol)?
    var cityName: String
    var isEmbedded: Bool = false
    let weatherService: WeatherSerivce
    var shouldGoBack = false
    
    @Published var data: [WeatherUIDataProtocol] = []
    @Published var isLoading: Bool = false
    
    init(isEmbedded: Bool = false,
         cityName: String,
         weatherService: WeatherSerivce) {
        self.isEmbedded = isEmbedded
        self.cityName = cityName
        self.weatherService = weatherService
    }
    
    deinit {
        print("Deinit \(String(describing: Self.self))")
    }
    
    @MainActor
    func updateData() async {
        self.isLoading = true
        await self.getWeeklyForecastData()
        self.isLoading = false
    }
    
    @MainActor
    private func getWeeklyForecastData() async {
        do {
            let weatherResponseDataArr = try await weatherService.getWeeklyForecastWeather(forCity: cityName)
            data = []
            weatherResponseDataArr.forEach { weather in
                let weatherHourUI = WeatherUIData(weatherDaily: weather)
                data.append(weatherHourUI)
            }
        } catch {
            router?.handleError(error: error)
        }
    }
}
