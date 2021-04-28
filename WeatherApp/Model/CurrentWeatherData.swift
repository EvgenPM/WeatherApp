//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by admin on 15.03.2021.
//  Copyright © 2021 admin. All rights reserved.
//

import Foundation
struct CurrentWeatherData: Codable {
    let main: Main
    let name: String
    let weather:[Weather]
}
struct Main:Codable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}
struct Weather:Codable {
    let id: Int
}
