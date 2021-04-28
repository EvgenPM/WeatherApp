//
//  ViewController.swift
//  WeatherApp
//
//  Created by admin on 14.03.2021.
//  Copyright © 2021 admin. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var fillsLikeTemp: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self  else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
    }
    
    func updateInterfaceWith(weather:CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityname
            self.temperatureLabel.text = weather.temperatureString
            self.fillsLikeTemp.text = weather.feelsLikeTemperatureString
            self.weatherIcon.image = UIImage(systemName: weather.systemIconNameString)
        }
        
    }
   
    @IBAction func searchPressed(_ sender: UIButton) {
        presentSearch(title: "Enter city", message: nil, style: .alert) { [unowned self]city in
            self.networkWeatherManager.getCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
}
extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.getCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
