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
    
    let key = "0a3080e5ebc094338e3a5fb7196e390b"
    let baseUrl = "https://api.darksky.net/forecast"
    var location: LocationElement?
    
    var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }

}
