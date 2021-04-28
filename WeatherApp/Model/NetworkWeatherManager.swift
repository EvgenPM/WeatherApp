//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by admin on 14.03.2021.
//  Copyright © 2021 admin. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city:String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func getCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        case .coordinate(let latitude,let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
        
        
    func performRequest(withURLString urlString:String){
    guard let url = URL(string: urlString) else { return }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, responce, error in
        if data == data {
           if let currentWeather = self.ParseJSON(withData: data!) {
                self.onCompletion?(currentWeather)
            }
        }
    }
     task.resume()
    }

 func ParseJSON(withData data: Data) -> CurrentWeather? {
          let decoder = JSONDecoder()
          do {
              let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
          }
          catch let error as NSError {
            print(error.localizedDescription)
    }
    return nil
    }
}

