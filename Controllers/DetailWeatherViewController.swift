//
//  DetailWeatherViewController.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 10/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit
import Alamofire
//Location
//import MapKit
//import CoreLocation

class DetailWeatherViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var temperatureImageView: UIImageView!
    @IBOutlet weak var collectionViewHourly: UICollectionView!
    @IBOutlet weak var tableViewWeekly: UITableView!
    
    let baseUrl = "https://api.darksky.net/forecast"
    var location: LocationElement?
    
    var weather: Weather?
    //var hourlyDataList = [Currently]()
    
    //let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewHourly.dataSource = self
        collectionViewHourly.delegate = self
        tableViewWeekly.dataSource = self
        
        let nib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: Bundle.main)
        collectionViewHourly.register(nib, forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
        let tableNib = UINib(nibName: "WeeklyTableViewCell", bundle: Bundle.main)
        tableViewWeekly.register(tableNib, forCellReuseIdentifier: "WeeklyTableViewCell")
        
        //currentTemperatureLabel.text = location?.name
        navigationItem.title = location?.name
        //getWeatherData()
        if weather == nil {
            getWeatherData()
        }else {
            updateUI()
        }
        
        //readFromJSON()
        
//        locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
    }
    
    func getWeatherData() {
        Alamofire.request("https://api.darksky.net/forecast/\(Constant.API_DARK_SKY)/\(location?.lat ?? 23.719999),\(location?.lon ?? 90.409999)", method: .get).responseData { response in
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: value)
                    self.weather = weather
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func readFromJSON() {
        let jsonURL = Bundle.main.url(forResource: "weatherData", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let weather = try JSONDecoder().decode(Weather.self, from: jsonData)
            self.weather = weather
            updateUI()
        } catch {
            print(error)
        }
    }
    
    func updateUI() {
        guard let weather = self.weather else { return }
        temperatureImageView.image = UIImage(named: "storm")
        //let temperatureInCelciuus = (Int) ((weather.currently.temperature - 32) * 0.56)
        let temperatureInCelciuus = String(format: "%.0f", weather.currently.temperature)
        currentTemperatureLabel.text = "\(temperatureInCelciuus)°C"
        //hourlyDataList = weather.hourly.data
        collectionViewHourly.reloadData()
        self.weather = weather
        tableViewWeekly.reloadData()
    }
    
}

extension DetailWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return hourlyDataList.count
        return weather?.hourly.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
//        let hourly = hourlyDataList[indexPath.row]
//        cell.weatherLabel.text = "\(hourly.temperature)°C"
//        cell.weatherImage.image = UIImage(named: "storm")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        
        if let hourly = weather?.hourly.data[indexPath.row] {
            let temperatureInCelciuus = (Int) ((hourly.temperature - 32) * 0.56)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            let time = Date(timeIntervalSince1970: TimeInterval(hourly.time))
            
            cell.temperatureLabel.text = "\(temperatureInCelciuus)°C"
            cell.weatherImageView.image = UIImage(named: "storm")
            cell.timeLabel.text = "\(dateFormatter.string(from: time))"
        }
        
        return cell
    }
    
}

extension DetailWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.daily.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewWeekly.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell", for: indexPath) as! WeeklyTableViewCell
        let dailyData = weather?.daily.data[indexPath.row]
        let temperatureInCelciuus = (Int) ((dailyData?.temperatureHigh ?? 100 - 32) * 0.56)
        cell.labelMaxTemperature.text = "\(temperatureInCelciuus)°C"
        let minTemp = (Int) ((dailyData?.temperatureLow ?? 100 - 32) * 0.56)
        cell.labelMinTemperature.text = "\(minTemp)°C"
        cell.imageTemperature.image = UIImage(named: "storm")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let time = Date(timeIntervalSince1970: TimeInterval(dailyData?.time ?? 152837))
        let date = dateFormatter.date(from: dateFormatter.string(from: time))
        dateFormatter.dateFormat = "EEEE"
        cell.labelWeekName.text = "\(dateFormatter.string(from: date!))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weekly Forecast"
    }
    
    
}
