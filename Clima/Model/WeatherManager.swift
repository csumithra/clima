//
//  WeatherManager.swift
//  Clima
//
//  Created by Sumithra Candasamy on 12/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, wmodel: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=1adc92268ecf796e4a470ef813975ac4&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        
        // 1) Create a URL
        if let url = URL(string: urlString) {
            // 2) Create a URL Session
            let session = URLSession(configuration: .default)
            
            // 3) Give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate!.didFailWithError(error: error!)
                    return // break from loop // dont execute further
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate!.didUpdateWeather(weatherManager: self, wmodel: weather)
                        
                    }
                }
            }
        
            // 4) Start the task
            task.resume()
            
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let docodedData = try decoder.decode(weatherStruct.self, from: weatherData)
            
            let city = docodedData.name
            let temp = docodedData.main.temp
            let id = docodedData.weather[0].id
            
            let weatherObj = WeatherModel(name: city, temp: temp, conditionId: id)
  
            return weatherObj
        } catch {
            delegate!.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
}
