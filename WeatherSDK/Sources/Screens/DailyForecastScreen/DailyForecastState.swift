//
//  DailyForecastState.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 24.10.24.
//

protocol DailyForecastStateProtocol: BasicStateProtocol {
    var shouldGoBack: Bool { get set }
    var data: [WeatherUIData] { get set }
    var weatherService: WeatherSerivce { get }
    func updateData() async
}

final internal class DailyForecastState: DailyForecastStateProtocol, ObservableObject {
    var isEmbedded: Bool = false
    var error: Error?
    @Published var cityName: String = ""
    @Published var data: [WeatherUIData] = []
    
                                            /*[WeatherUIData(),
                                               WeatherUIData(),
                                               WeatherUIData()]*/ //For Preview
    @Published var isLoading = false
    @Published var shouldGoBack = false
    //For preview
//      self.currentWeatherData =  WeatherUIData(weatherDTO: CurrentWeatherDTO(temperature: 14, weather: Weather(description: "Clear sky"), dateTime: "20"), cityName: "Munich")
    
    let weatherService: WeatherSerivce

    
    init(cityName: String,
        weatherService: WeatherSerivce,
        isEmbedded: Bool = false) {
        self.cityName = cityName
        self.weatherService = weatherService
        self.isEmbedded = isEmbedded
        
    }
    
    deinit {
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
            print(error.localizedDescription)
        }
    }
}
