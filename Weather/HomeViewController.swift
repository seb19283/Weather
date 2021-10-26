//
//  ViewController.swift
//  Weather
//
//  Created by Sebastian Connelly on 10/25/21.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    // Default values
    private struct Constants {
        static let locationButtonName: String = "Refresh"
        static let defaultCity: String = "Montreal"
        static let defaultLatitude: Double = 45.5017
        static let defaultLongitude: Double = 73.5673
        static let reuseID: String = "cellID"
    }
    
    private lazy var locationBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(locationButtonTapped))
        return barButton
    }()
    
    private lazy var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: Constants.reuseID)
        return tableView
    }()
    
    private var locationManager: CLLocationManager?
    private var dailyWeather: WeatherAPIResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.delegate = self
        
        self.updateLocation()
        self.layoutSubviews()
    }
    
    private func updateLocation() {
        let defaults = UserDefaults.standard
        
        var city: String
        var latitude: Double
        var longitude: Double
        
        // Get current locations if available otherwise use default ones
        if let currentCity = defaults.value(forKey: "City") as? String, let lat = defaults.value(forKey: "Latitude") as? Double, let long = defaults.value(forKey: "Longitude") as? Double {
            city = currentCity
            latitude = lat
            longitude = long
        } else {
            city = Constants.defaultCity
            latitude = Constants.defaultLatitude
            longitude = Constants.defaultLongitude
        }
        
        self.title = "Weather for \(city)"
        
        // Set up the API call for this city with all the required info
        let apiCall = WeatherAPICall(lat: latitude, long: longitude, city: city)
        
        // Get the weather data for this city and then reload table view with new data
        WeatherManager.sharedInstance.getWeather(for: apiCall) { response in
            DispatchQueue.main.async {
                self.dailyWeather = response
                self.weatherTableView.reloadData()
            }
        }
    }
    
    private func layoutSubviews() {
        self.navigationItem.rightBarButtonItem = locationBarButton
        
        self.view.addSubview(weatherTableView)
        weatherTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        weatherTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        weatherTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    // When user refreshes ask if they can enable location and then get their location
    @objc func locationButtonTapped() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }
}

//MARK: -- UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dailies = dailyWeather?.dailies else {
            weatherTableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        // Set up detail text view and then push it onto navigation controller
        let detailVC = DetailViewController()
        detailVC.currentWeather = dailies[indexPath.row]
        detailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        weatherTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: -- UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let daily = dailyWeather {
            return daily.dailies.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath) as? WeatherTableViewCell, let day = dailyWeather?.dailies[indexPath.row] else {
            return UITableViewCell()
        }
        
        // Set up labels to display date, icon, and his/lows for day
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        cell.dayLabel.text = dateFormatter.string(from: day.date)
        cell.iconImageView.loadImageWithCache(url: day.imageURL)
        cell.weatherLabel.text = "Hi: \(day.high)°F, Low: \(day.low)°F"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Default height just because it works. Didn't bother calculating exact height needed
        return 60
    }
}

// MARK: -- CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // Update user location data with values we just pulled
        let longitude = location.coordinate.longitude as Double
        let latitude = location.coordinate.latitude as Double
        
        UserDefaults.standard.set(longitude, forKey: "Longitude")
        UserDefaults.standard.set(latitude, forKey: "Latitude")
        
        getCityName(location: location)
    }
    
    private func getCityName(location: CLLocation) {
        // Query city name from location data to then display as title
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.last, let city = placemark.locality else {
                self.updateLocation()
                return
            }
            
            UserDefaults.standard.set(city, forKey: "City")
            self.updateLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        // If they just allowed us location access query their location
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
}
