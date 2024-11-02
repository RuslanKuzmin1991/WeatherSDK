//
//  MainState.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

import SwiftUI
import UIKit
import WeatherSDK

protocol MainState: ObservableObject {
    var isEmbedded: Bool { get set }
    var cityName: String { get set }
    func onWeatherTap()
}

public class MainStateImpl: MainState {
    @Published var cityName: String
    @Published var isEmbedded: Bool = false
    var router: Router?
    
    init(router: Router?,
         isEmbedded: Bool = false,
         cityName: String = "") {
        self.cityName = cityName
        self.router = router
        self.isEmbedded = isEmbedded
    }
    
    func onWeatherTap() {
        uiKitNavigation()
    }

    private func uiKitNavigation() {
        router?.navigateToWeatherScreen(forCity: cityName,
                                        withNavigationType: .push,
                                        animated: false)
    }
}
