//
//  DetailWeatherViewController.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 10/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit
import Alamofire

class DetailWeatherViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var temperatureImageView: UIImageView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    let key = "0a3080e5ebc094338e3a5fb7196e390b"
    let baseUrl = "https://api.darksky.net/forecast"
    var location: LocationElement?
    
    var weather: Weather?
    var hourlyDataList = [Currently]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        
        let nib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: Bundle.main)
        hourlyCollectionView.register(nib, forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
        
        //currentTemperatureLabel.text = location?.name
        navigationItem.title = location?.name
        getWeatherData()
    }
    
    func getWeatherData() {
        //let params: Parameters = ["key": key, "latitude": location?.lat ?? "23.719999", "longitude": location?.lon ?? "90.409999"]
        Alamofire.request("https://api.darksky.net/forecast/0a3080e5ebc094338e3a5fb7196e390b/\(location?.lat ?? 23.719999),\(location?.lon ?? 90.409999)", method: .get).responseData { response in
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: value)
                    DispatchQueue.main.async {
                        self.updateUI(weather: weather)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        //        Alamofire.request(baseUrl, method: .post, parameters: params).responseJSON { (response) in
        //            print(response.result.value)
        //        }
    }
    
    func updateUI(weather: Weather) {
        temperatureImageView.image = UIImage(named: "storm")
        let temperatureInCelciuus = (Int) ((weather.currently.temperature - 32) * 0.56)
        currentTemperatureLabel.text = "\(temperatureInCelciuus)°C"
        hourlyDataList = weather.hourly.data
        hourlyCollectionView.reloadData()
    }
    
}

extension DetailWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
//        let hourly = hourlyDataList[indexPath.row]
//        cell.weatherLabel.text = "\(hourly.temperature)°C"
//        cell.weatherImage.image = UIImage(named: "storm")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        let hourly = hourlyDataList[indexPath.row]
        let temperatureInCelciuus = (Int) ((hourly.temperature - 32) * 0.56)
        cell.temperatureLabel.text = "\(temperatureInCelciuus)°C"
        cell.weatherImageView.image = UIImage(named: "storm")
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let time = Date(timeIntervalSince1970: TimeInterval(hourly.time))
        //print(dateFormatter.string(from: dateTime))
        
        cell.timeLabel.text = "\(dateFormatter.string(from: time))"
        
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .full
//
//        let formattedString = formatter.string(from: TimeInterval(hourly.time))!
//        print(formattedString)
        
        return cell
    }
    
    
}
