//
//  Structs.swift
//  Weather
//
//  Created by Sebastian Connelly on 10/26/21.
//

import Foundation
import UIKit

struct WeatherAPICall {
    var lat: Double
    var long: Double
    var city: String
    var exclude: String = "minutely,hourly,alerts"
    var units: String = "imperial"
    
    // Generates proper api string with all of our data we want queried
    func generateString(apiKey: String) -> String {
        return "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=\(exclude)&units=\(units)&appid=\(apiKey)"
    }
}

// For current app this isn't necessary but is useful if we ever want to gather more data than just the daily tab
struct WeatherAPIResponse {
    var dailies: [DailyWeather]
    
    init(dict: NSDictionary) {
        self.dailies = [DailyWeather]()
        
        if let dailyReports = dict["daily"] as? [NSDictionary] {
            for day in dailyReports {
                self.dailies.append(DailyWeather(dict: day))
            }
        }
    }
}

// This parses all of the data from our JSON object into the fields we need
struct DailyWeather {
    var date: Date
    var high: Int
    var low: Int
    var imageURL: String
    var description: String
    
    init(dict: NSDictionary) {
        // For some reason dict["weather"] is being read in as an NSArray with an NSDictionary as it's first and only value
        if let dt = dict["dt"] as? Double, let temp = dict["temp"] as? NSDictionary, let low = temp["min"] as? Double, let high = temp["max"] as? Double, let weatherArr = dict["weather"] as? NSArray, let weather = weatherArr[0] as? NSDictionary, let description = weather["description"] as? String, let icon = weather["icon"] as? String {
            self.date = Date(timeIntervalSince1970: dt)
            self.high = Int(high)
            self.low = Int(low)
            
            //Forced to allow arbitrary loads because this icon is at an http website
            self.imageURL = "http://openweathermap.org/img/wn/\(icon)@2x.png"
            self.description = description
        } else {
            // Would refactor this out to be a bunch of optionals and then unwrap in main function normally
            self.date = Date()
            self.high = 0
            self.low = 0
            self.imageURL = ""
            self.description = ""
        }
    }
}
