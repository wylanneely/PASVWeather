//
//  WeatherObject.swift
//  WeatherAPI
//
//  Created by Wylan L Neely on 1/25/25.
//

import Foundation

struct WeatherObject {
    
    let cityName: String?
    let region: String?
    let country: String?
    
    let tempCelcius: Double?
    let tempFahrenheit: Double?
    let humidity: Double?
    let uv: Double?
    let feelsLikeC: Double?
    let feelsLikeF: Double?
    let iconURL: URL?
    let currentIconText: String?
    
    init?(json:[String:Any]){
        
        if let current = json["current"] as? [String: Any],
        let location = json["location"] as? [String: Any] {
            cityName = location["name"] as? String ?? nil
            region = location["region"] as? String ?? nil
            country = location["country"] as? String ?? nil
            tempCelcius = current["temp_c"] as? Double ?? nil
            tempFahrenheit = current["temp_f"] as? Double ?? nil
            humidity = current["humidity"] as? Double ?? nil
            uv = current["uv"] as? Double ?? nil
            feelsLikeC = current["feelslike_c"] as? Double ?? nil
            feelsLikeF = current["feelslike_f"] as? Double ?? nil
            
            let condition = current["condition"] as? [String:Any] ?? nil
            if let iconURLString = condition?["icon"] as? String {
                iconURL = URL(string: iconURLString.hasPrefix("http") ? iconURLString : "https:" + iconURLString) ?? nil
            } else {
                iconURL = nil
            }
            currentIconText = condition?["text"] as? String ?? nil
        } else {
            return nil
        }
    }
    
}
