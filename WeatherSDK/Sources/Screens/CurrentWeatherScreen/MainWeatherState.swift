//
//  ForecastState.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

protocol MainWeatherStateProtocol {
    var shouldGoBack: Bool { get set }
    var isEmbedded: Bool { get set }
    var delegate: WeatherSDKDelegate? { get set }
    var cityName: String { get set }
    var isLoading: Bool { get set }
    var currentWeatherData: WeatherUIData { get set }
    var weatherService: WeatherSerivce { get }
    func updateData() async
    func onDailyForecastTap()
}

final internal class MainWeatherState: MainWeatherStateProtocol, ObservableObject {
    var isEmbedded: Bool = false
    var delegate: WeatherSDKDelegate?
    var error: Error?
    @Published var cityName: String = ""
    @Published var isLoading = false
    @Published var shouldGoBack = false
    @Published var currentWeatherData: WeatherUIData = WeatherUIData()
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
        if error == nil {
            delegate?.onFinished()
        }
    }
    
    func onDailyForecastTap() {
        
    }
  
    @MainActor
    func updateData() async {
        self.isLoading = true
        await self.getCurrentData()
        self.isLoading = false
    }
    
    @MainActor
    private func getCurrentData() async {
        do {
            if let data = try await weatherService.getCurrentWeather(forCity: cityName) {
                await MainActor.run {
                    self.currentWeatherData = WeatherUIData(weatherDTO: data, cityName: cityName)
                }
            }
        } catch {
            if self.error == nil {
                self.error = error
                if !isEmbedded {
                    shouldGoBack = true
                }
                delegate?.onFinishedWithError(error: error)
            }
        }
    }
}
