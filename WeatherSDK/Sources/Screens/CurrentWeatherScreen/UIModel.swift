//
//  Model.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 19.10.24.
//

import Foundation

let iconUrlString = "https://cdn.weatherbit.io/static/img/icons/"

internal struct WeatherUIData {
    var id = UUID()
    var title: String = ""
    var temp: String = ""
    var weather: String = ""
    var time: String = ""
    var icon: URL?
    
    init() {}
    
    init(weatherDTO: CurrentWeatherDTO,
          cityName: String) {
        let formatedTime = weatherDTO.dateTime.formatTimeHoursAndMinutes ?? weatherDTO.dateTime
        let localizedCityNameString = String(format: "weather_in_city_label".localized, cityName)
        let localizedTimeString = String(format: "time_in_city_label".localized, formatedTime)
        let localizedTemperatureString = String(format: "temperature_in_city_label".localized, weatherDTO.temperature)
        self.title = localizedCityNameString
        self.temp = localizedTemperatureString
        self.weather = weatherDTO.weather.description
        self.time = localizedTimeString
        let icon = weatherDTO.weather.icon
        let urlStr = iconUrlString + icon + ".png"
        self.icon = URL(string: urlStr)
    }
    
    init(weatherDTO: WeatherDTO) {
        let formatedTime = weatherDTO.timestampUtc.formatTime ?? weatherDTO.timestampUtc
        let localizedTemperatureString = String(format: "temperature_in_city_label".localized, weatherDTO.temp)
        self.title = formatedTime
        self.temp = localizedTemperatureString
        self.weather = weatherDTO.weather.description
        let icon = weatherDTO.weather.icon
        let urlStr = iconUrlString + icon + ".png"
        self.icon = URL(string: urlStr)
    }
}
