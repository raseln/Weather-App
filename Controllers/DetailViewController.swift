//
//  DetailViewController.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 17/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {

    @IBOutlet weak var tableViewDetail: UITableView!
    var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDetail.delegate = self
        tableViewDetail.dataSource = self
        
        let tableNib = UINib(nibName: "WeeklyTableViewCell", bundle: Bundle.main)
        tableViewDetail.register(tableNib, forCellReuseIdentifier: "WeeklyTableViewCell")
        tableViewDetail.register(UINib(nibName: "CurrentWeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CurrentWeatherTableViewCell")
        let hourlyNib = UINib(nibName: "HourlyTableViewCell", bundle: Bundle.main)
        tableViewDetail.register(hourlyNib, forCellReuseIdentifier: "HourlyTableViewCell")
    }

}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1
            
        case 2:
            return weather?.daily.data.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let currentWeatherCell = tableViewDetail.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
            
            if let currentWeather = weather?.currently {
                currentWeatherCell.labelCurrentTemperature.text = "\(String(format: "%.0f", currentWeather.temperature))°C"
                currentWeatherCell.imageCurrentTemperature.image = getIcon(icon: currentWeather.icon)
                currentWeatherCell.labelSummary.text = "Summary: \(currentWeather.summary)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                let time = Date(timeIntervalSince1970: TimeInterval(currentWeather.time))
                
                currentWeatherCell.labelCurrentTime.text = "\(dateFormatter.string(from: time))"
            }
            
            return currentWeatherCell
            
        case 1:
            let hourleCell = tableViewDetail.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
//            let defaultCell = tableViewDetail.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
//
//            return defaultCell
            //hourleCell.collectionView.dataSource = self
            hourleCell.hourlyData = weather?.hourly
            
            return hourleCell
            
        case 2:
            let weeklyCell = tableViewDetail.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell", for: indexPath) as! WeeklyTableViewCell
            
            if let dailyData = weather?.daily.data[indexPath.row] {
                let maxTemperature = (Int) (dailyData.temperatureHigh * 0.56)
                weeklyCell.labelMaxTemperature.text = "\(maxTemperature)°C"
                let minTemperature = (Int) (dailyData.temperatureLow * 0.56)
                weeklyCell.labelMinTemperature.text = "\(minTemperature)°C"
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                let time = Date(timeIntervalSince1970: TimeInterval(dailyData.time))
                let date = dateFormatter.date(from: dateFormatter.string(from: time))
                dateFormatter.dateFormat = "EEEE"
                weeklyCell.labelWeekName.text = "\(dateFormatter.string(from: date!))"
                weeklyCell.imageTemperature.image = getIcon(icon: dailyData.icon)
            }
            
            return weeklyCell
            
        default:
            let defaultCell = tableViewDetail.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
            return defaultCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Current Weather"
            
        case 1:
            return "Hourly Forecast"
            
        case 2:
            return "Weekly Forecast"
            
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
            
        case 1:
            return 120
            
        case 2:
            return 80
            
        default:
            return 100
        }
    }
    
    func getIcon(icon: Icon) -> UIImage {
        switch icon {
        case .cloudy:
            return UIImage(named: "cloudy")!
            
        case .clearDay:
            return UIImage(named: "cloudy")!
            
        case .rain:
            return UIImage(named: "rain")!
            
        case .snow:
            return UIImage(named: "snow")!
            
        case .clearNight:
            return UIImage(named: "clear-night")!
            
        case .sleet:
            return UIImage(named: "sleet")!
            
        case .wind:
            return UIImage(named: "wind")!
            
        case .fog:
            return UIImage(named: "fog")!
            
        case .partlyCloudyNight:
            return UIImage(named: "partly-cloudy-night")!
            
        default:
            return UIImage(named: "partly-cloudy-day")!
        }
    }
}
