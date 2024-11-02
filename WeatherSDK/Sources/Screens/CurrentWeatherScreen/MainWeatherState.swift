//
//  ForecastState.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

protocol MainWeatherStateProtocol: BasicStateProtocol {
    var shouldGoBack: Bool { get set }
    var delegate: WeatherSDKDelegate? { get set }
    var currentWeatherData: WeatherUIData { get set }
    func updateData() async
    func onDailyForecastTap()
    func onWeeklyForecastTap()
}

final internal class MainWeatherState: MainWeatherStateProtocol,
                                       ObservableObject {
    var router: (any RouterProtocol)?
    var isEmbedded: Bool = false
    var delegate: WeatherSDKDelegate?
    var error: Error?
    let weatherService: WeatherSerivce
    @Published var cityName: String = ""
    @Published var isLoading = false
    @Published var shouldGoBack = false
    @Published var currentWeatherData: WeatherUIData = WeatherUIData()
    //For preview
//      self.currentWeatherData =  WeatherUIData(weatherDTO: CurrentWeatherDTO(temperature: 14, weather: Weather(description: "Clear sky"), dateTime: "20"), cityName: "Munich")
    
    init(cityName: String,
        weatherService: WeatherSerivce,
        isEmbedded: Bool = false) {
        self.cityName = cityName
        self.weatherService = weatherService
        self.isEmbedded = isEmbedded
        
    }
    
    deinit {
//        if error == nil {
//            delegate?.onFinished()
//        }
    }
    
    func onDailyForecastTap() {
        self.router?.navigateToDailyForecast(forCity: cityName,
                                             animated: true)
    }
  
    func onWeeklyForecastTap() {
        self.router?.navigateToWeeklyForecast(forCity: cityName,
                                              animated: true)
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
            let data = try await weatherService.getCurrentWeather(forCity: cityName)
            self.currentWeatherData = WeatherUIData(weatherDTO: data, cityName: cityName)
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
