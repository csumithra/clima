//
//  WeatherStruct.swift
//  Clima
//
//  Created by Sumithra Candasamy on 12/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct weatherStruct: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let description: String
    
}
