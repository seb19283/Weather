//
//  WeatherManager.swift
//  Weather
//
//  Created by Sebastian Connelly on 10/25/21.
//

import Foundation

class WeatherManager {
    private struct Constants {
        static let apiKey: String = "a716a1ee928aea6e7be1b0950aaa7e97"
    }
    
    // Using singleton because we don't need multiple copies of out manager class
    static let sharedInstance = WeatherManager()
    var cache: NSCache<AnyObject, AnyObject>
    
    private init() {
        // If I had more time I would have stored this so it wasn't just city but also city/date as well as potentially have it persist through app launches
        self.cache = NSCache<AnyObject, AnyObject>()
    }
    
    // Queries the API and gets data for current location. If already in cache return that value
    func getWeather(for apiCall: WeatherAPICall, completion: @escaping ((WeatherAPIResponse?) -> Void)) {
        let urlString = apiCall.generateString(apiKey: Constants.apiKey)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        if let cachedDict = cache.object(forKey: apiCall.city as AnyObject) as? NSDictionary {
            self.parseJSON(dict: cachedDict, completion: completion)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            if let data = data, let dict = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? NSDictionary {
                self.cache.setObject(dict, forKey: apiCall.city as AnyObject)
                self.parseJSON(dict: dict, completion: completion)
            } else {
                completion(nil)
                return
            }
        }.resume()
    }
    
    // Parse the JSON object. Function not really necessary but useful if we want to parse more stuff
    private func parseJSON(dict: NSDictionary, completion: @escaping ((WeatherAPIResponse?) -> Void)) {
        let response = WeatherAPIResponse(dict: dict)
        
        completion(response)
    }
    
}
