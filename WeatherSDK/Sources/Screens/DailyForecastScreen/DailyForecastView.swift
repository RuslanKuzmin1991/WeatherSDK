//
//  DailyForecastScreen.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 24.10.24.
//
import SwiftUI

internal struct DailyForecastView: View {
    @StateObject var state: DailyForecastState
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            if !state.isEmbedded {
                VStack {
                }
                .navigationTitle(String(format: "daily_forecast_navigation_title".localized, state.cityName))
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
                    List {
                        ForEach(state.data.indices, id: \.self) { index in
                            Row(entity: state.data[index])
                                .alignmentGuide(.listRowSeparatorLeading) { _ in
                                    return -20
                                }
                            
                        }
                    }.padding(.horizontal, 0)
                        .padding(.top, 8)
                        .listStyle(.plain)
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
    func Row(entity: WeatherUIData) -> some View {
        HStack(spacing: 10) {
            Text(entity.title)
                .font(.textRegular)
                .foregroundStyle(.textPrimary)
            
            Text(entity.temp)
                .font(.h2)
                .foregroundStyle(.textPrimary)
            
            Text(entity.weather)
                .font(.textRegular)
                .foregroundStyle(.textPrimary)
            AsyncImage(url: entity.icon) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
                    .controlSize(.regular)
            }.frame(width: 50, height: 50)
            .padding(.leading, 10)
            Spacer()
        }
        .padding(.all, 8)
        .background(.white)
    }
}
    
 

#Preview {
    let weatherSerivce = WeatherNetworkSerivce(key: "")
    let state = DailyForecastState(cityName: "Munich",
                                  weatherService: weatherSerivce)
    DailyForecastView(state: state)
}

