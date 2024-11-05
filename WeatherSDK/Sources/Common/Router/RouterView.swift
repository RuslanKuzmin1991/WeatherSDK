//
//  RouterView.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 03.11.24.
//

import SwiftUI

public enum Destination: Codable,
                         Hashable {
    case dailyForecast(city: String)
    case weeklyForecast(city: String)
}

final class RouterView: ObservableObject,
                        RouterProtocol {
    func handleError(error: any Error) {
        
    }
    
    func handleSuccess() {
        
    }
    
    func navigateToDailyForecast(forCity city: String,
                                 animated: Bool = false) {
        navPath.append(Destination.dailyForecast(city: city))
    }
    
    func navigateToWeeklyForecast(forCity city: String,
                                  animated: Bool = false) {
        navPath.append(Destination.weeklyForecast(city: city))
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
