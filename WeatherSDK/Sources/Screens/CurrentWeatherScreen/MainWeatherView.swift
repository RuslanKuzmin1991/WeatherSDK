//
//  ForecastView.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

import SwiftUI

internal struct MainWeatherView: View {
    //TODO: Temp implementation. Needs to be improved
    @State var weatherViewIsOn: Bool = false
    @State var dailyForecaseViewIsOn: Bool = false
    @State var weeklyForecaseViewIsOn: Bool = false
    
    @StateObject var state: MainWeatherState
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            if !state.isEmbedded {
                VStack {
                }
                .navigationTitle(String(format: "navigation_title".localized, state.cityName))
                .font(.title)
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor.navigationBar
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            VStack {
                if state.isLoading {
                    Spacer()
                    ProgressView()
                        .controlSize(.large)
                    Spacer()
                } else {
                    Spacer()
                    Content(weatherData: state.currentWeatherData)
                        .padding(.vertical, 16)
                    NavigationButtons()
                    Spacer()
                }
            }.onChange(of: state.shouldGoBack) { newValue in
                if newValue {
                    dismiss()
                }
            }
            .padding(.vertical, 0)
            .task {
                await state.updateData()
            }
        }
    }
    
    @ViewBuilder
    func Content(weatherData: WeatherUIData) -> some View {
        VStack(spacing: 4) {
                Text(weatherData.title)
                    .foregroundStyle(.textPrimary)
                    .font(.h2)
                Text(weatherData.temp)
                    .foregroundStyle(.textPrimary)
                    .font(.header)
                    .padding(.vertical, 4)
                Text(weatherData.weather)
                .foregroundStyle(.textPrimary)
                    .font(.title)
                    .font(.h2)
                Text(weatherData.time)
                    .foregroundStyle(.textSecondary)
                    .font(.title)
                    .padding(.top, 8)
                AsyncImage(url: weatherData.icon) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                        .controlSize(.regular)
                }.frame(width: 100, height: 100)
        }.padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func NavigationButtons() -> some View {
        VStack(spacing: 10) {
            Button {
                //TODO: SwiftUI Navigation. Need to be uncommented for usage
//                weatherViewIsOn.toggle()
                        state.onDailyForecastTap()
            } label: {
                HStack {
                    Text("weather_screen_detail_forecast_button_title".localized)
                        .padding(.horizontal, 0)
                        .foregroundStyle(.control)
                        .font(.title)
                }
            }
            
            Button {
                //TODO: SwiftUI Navigation. Need to be uncommented for usage
//                weatherViewIsOn.toggle()
//                dailyForecaseViewIsOn.toggle()
                        state.onDailyForecastTap()
            } label: {
                HStack {
                    Text("weather_screen_daily_forecast_button_title".localized)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 0)
                        .foregroundStyle(.control)
                        .font(.title)
                }
            }
            Button {
                //TODO: SwiftUI Navigation. Need to be uncommented for usage
//                weatherViewIsOn.toggle()
//                weeklyForecaseViewIsOn.toggle()
                        state.onWeeklyForecastTap()
            } label: {
                HStack {
                    Text("weather_screen_weekly_forecast_button_title".localized)
                        .padding(.horizontal, 0)
                        .foregroundStyle(.control)
                        .font(.title)
                }
            }
            Button {
                //TODO: SwiftUI Navigation. Need to be uncommented for usage
                weatherViewIsOn.toggle()
//                        state.onDailyForecastTap()
            } label: {
                HStack {
                    Text("weather_screen_history_request_button_title".localized)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 0)
                        .foregroundStyle(.control)
                        .font(.title)
                }
            }//TODO: Temp solution
            .navigationDestination(isPresented: $weatherViewIsOn) {
                if weatherViewIsOn {
                    if dailyForecaseViewIsOn {
                        DailyForecastView(state: DailyForecastState(cityName: state.cityName, weatherService: state.weatherService))
                    } else if weeklyForecaseViewIsOn {
                        WeeklyForecastView(state: WeeklyForecastState(cityName: state.cityName, weatherService: state.weatherService))
                    }
                }
            }
        }
    }
}
    


#Preview {
    let weatherSerivce = WeatherNetworkSerivce(key: "")
    let state = MainWeatherState(cityName: "Munich",
                                  weatherService: weatherSerivce)
    MainWeatherView(state: state)
}





