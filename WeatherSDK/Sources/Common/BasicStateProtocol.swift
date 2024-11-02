//
//  BasicStateProtocol.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 29.10.24.
//

protocol BasicStateProtocol {
    var isEmbedded: Bool { get set }
    var isLoading: Bool { get set }
    var cityName: String { get set }
    var weatherService: WeatherSerivce { get }
    var router: RouterProtocol? { get }
    func updateData() async
}
