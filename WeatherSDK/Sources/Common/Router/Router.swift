//
//  Router.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 03.11.24.
//

protocol RouterProtocol {
    func navigateToDailyForecast(forCity city: String,
                                 animated: Bool)
    func navigateToWeeklyForecast(forCity city: String,
                                  animated: Bool)
    func handleError(error: any Error)
    func handleSuccess()
}
