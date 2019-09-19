//
//  ViewController.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 6/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
//import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    //Loading indicator
    let loadingView = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelCurrentLocation: UILabel!
    @IBOutlet weak var labelCurrentTemperature: UILabel!
    @IBOutlet weak var imageCurrentTemperature: UIImageView!
    @IBOutlet weak var labelRainProbability: UILabel!
//    @IBOutlet weak var labelAlertTitle: UILabel!
//    @IBOutlet weak var textViewAlertDescription: UITextView!
    
    //var location = LocationElement(id: 1, name: "Dhaka", region: "DHK", lat: 22.896734, lon: 91.847644)
    var locationList = [LocationElement]()
    //var loc: Results<LocationElement>?
    let locationManager = CLLocationManager()
    //var userCurrentLocation: CLLocation?
    var currentLocationWeather: Weather?
    var weatherList = [Weather]()
    
    let isConnected = Connectivity.isConnectedToInternet
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Loading indicator start //
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating();
        loadingView.view.addSubview(loadingIndicator)
        // Loading indicator end //
        
//        if Connectivity.isConnectedToInternet {
//            //print("Connected")
//            getPlaceList()
//        }else {
//            //print("Not connected")
//            labelCurrentTemperature.text = ""
//            labelCurrentLocation.text = "No internet connection"
//        }
        
        DispatchQueue.main.async {
            self.present(self.loadingView, animated: true)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let vc = self.presentedViewController, vc is UIAlertController {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        getPlaceList()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func showAlertDidTap(_ sender: UIButton) {
        var title = "Alert!"
        var description = "No alert found for current location"
        if let tempAlert = currentLocationWeather?.alerts?.first {
            title = tempAlert.title
            description = tempAlert.description
        }
        
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
        if let addViewController = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "PlaceAddViewController") as? PlaceAddViewController {
            addViewController.placeSavedFromChildViewController = {
                do {
                    let location = try Realm().objects(LocationElement.self).last
                    self.locationList.append(location._rlmInferWrappedType())
                    // Update Table Data
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: self.locationList.count - 1, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                } catch {
                    print(error)
                }
            }
            present(addViewController, animated: true)
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else {
            print("Error")
            return
        }
        
        //Show loading indicator
        //showLoadingView()
        
        //locationManager.stopUpdatingLocation()
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else {
                print(error ?? "No data")
                //self.hideLoadingView()
                return
            }
            //print(city + ", " + country)
            self.labelCurrentLocation.text = "Temperature of \(city), \(country)"
            self.updateCurrentLocationTemperature(location: location)
        }
    }
    
    func updateCurrentLocationTemperature(location: CLLocation) {
        if isConnected {
            Alamofire.request("https://api.darksky.net/forecast/API_KEY/\(location.coordinate.latitude),\(location.coordinate.longitude)", method: .get).responseData { response in
                if response.result.isFailure, let error = response.result.error {
                    print("Network Error: \(error.localizedDescription)")
                }
                
                if response.result.isSuccess, let value = response.result.value {
                    do {
                        var weather = try JSONDecoder().decode(Weather.self, from: value)
                        let temperatureInCelcius = (weather.currently.temperature - 32) * 0.56
                        weather.currently.temperature = temperatureInCelcius
                        self.currentLocationWeather = weather
                        self.labelCurrentTemperature.text = "\(String(format: "%.0f", temperatureInCelcius))°C"
                        self.imageCurrentTemperature.image = self.getIcon(icon: weather.currently.icon)
                        let rainProbability = (weather.currently.precipProbability * 100)
                        self.labelRainProbability.text = "Probability of rain today: \(String(format: "%.0f", rainProbability))%"
//                        if let alert = weather.alerts {
//                            self.labelAlertTitle.text = alert.first?.title
//                            self.textViewAlertDescription.text = alert.first?.description
//                        }else{
//                            self.labelAlertTitle.text = "No alert"
//                        }
                        
                    } catch {
                        print(error)
                    }
                }
                
                //self.hideLoadingView()
            }
            
        }else {
            labelCurrentTemperature.text = "No internet connection"
            //hideLoadingView()
        }
    }
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.present(self.loadingView, animated: true)
        }
    }
    
    func hideLoadingView() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            self.dismiss(animated: true, completion: nil)
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

    
    @IBAction func editButtonDidTap(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            tableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        }else {
            tableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
    
    func getPlaceList() {
        let realm = try! Realm()
        let locationElements = realm.objects(LocationElement.self)
        if locationElements.count > 0 {
            for item in locationElements {
                locationList.append(item)
            }
            
            tableView.reloadData()
        }
    }
    
//    func deleteLocationFromDatabase(location: LocationElement, indexPath: IndexPath) {
//        do {
//            try Realm().write {
//                try Realm().delete(location)
//            }
//
//            locationList.remove(at: indexPath.row)
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.endUpdates()
//
//        } catch {
//            print(error)
//        }
//    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let location = locationList[indexPath.row]
        
        cell.cityLable.text = location.name
        
//        let jsonURL = Bundle.main.url(forResource: "weatherData", withExtension: "json")!
//        do {
//            let jsonData = try Data(contentsOf: jsonURL)
//            var weather = try JSONDecoder().decode(Weather.self, from: jsonData)
//            let temperatureInCelciuus = (weather.currently.temperature - 32) * 0.56
//            weather.currently.temperature = temperatureInCelciuus
//            weatherList.append(weather)
//            cell.temperatureLabel.text = "\(String(format: "%.0f", temperatureInCelciuus))°C"
//            cell.temperatureImageView.image = getIcon(icon: weather.currently.icon)
//        } catch {
//            print("JSON Parse Error: \(error.localizedDescription)")
//        }
        
        //If network is available then call api for data
        if isConnected {
            Alamofire.request("https://api.darksky.net/forecast/API_KEY/\(location.lat),\(location.lon)", method: .get).responseData { response in
                if response.result.isFailure, let error = response.result.error {
                    print("Network Error: \(error.localizedDescription)")
                }

                if response.result.isSuccess, let value = response.result.value {
                    do {
                        var weather = try JSONDecoder().decode(Weather.self, from: value)
                        let temperatureInCelciuus = (weather.currently.temperature - 32) * 0.56
                        weather.currently.temperature = temperatureInCelciuus
                        self.weatherList.insert(weather, at: indexPath.row)
                        //self.weatherList.append(weather)
                        cell.temperatureLabel.text = "\(String(format: "%.0f", temperatureInCelciuus))°C"
                        cell.temperatureImageView.image = UIImage(named: "storm")
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
        return cell
    }
    
    func readPlaceFromJSON() {
        let jsonURL = Bundle.main.url(forResource: "placeData", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let places = try JSONDecoder().decode([LocationElement].self, from: jsonData)
            locationList = places
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main)
//            .instantiateViewController(withIdentifier: "DetailWeatherViewController") as! DetailWeatherViewController
//
//        let location = locationList[indexPath.row]
//        detailViewController.location = location
        
        let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        if indexPath.row <= weatherList.count {
            detailViewController.weather = weatherList[indexPath.row]
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let location = locationList[indexPath.row]
        //deleteLocationFromDatabase(location: location, indexPath: indexPath)
        do {
            try Realm().write {
                try Realm().delete(location)
            }
            
            locationList.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved Places"
    }
    
}


//extension ViewController: DataAddedFromChildController {
//    func onDataAdded() {
//        do {
//            let location = try Realm().objects(LocationElement.self).last
//            print(location?.name ?? "No data")
//        } catch {
//            print(error)
//        }
//    }
//}
