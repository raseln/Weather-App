//
//  HourlyTableViewCell.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 18/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var hourlyData: Hourly?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.dataSource = self
        let nib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        if let hourly = hourlyData?.data[indexPath.row] {
            
            let temperatureInCelciuus = (hourly.temperature - 32) * 0.56
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "HH:00"
            let time = Date(timeIntervalSince1970: TimeInterval(hourly.time))
            
            cell.temperatureLabel.text = "\(String(format: "%.0f", temperatureInCelciuus))°C"
            cell.weatherImageView.image = getIcon(icon: hourly.icon)
            cell.timeLabel.text = "\(dateFormatter.string(from: time))"
            
            cell.contentView.layer.cornerRadius = 5.0
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
            cell.contentView.layer.masksToBounds = true;
            
        }
        
        return cell
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: <#T##Int#>)
//    }
}
