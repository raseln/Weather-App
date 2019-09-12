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

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var location = LocationElement(id: 1, name: "Dhaka", region: "DHK", lat: 22.896734, lon: 91.847644)
    var locationList = [LocationElement]()
    //var loc: Results<LocationElement>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getPlaceList()
    }
    
    @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
        if let addViewController = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "PlaceAddViewController") as? PlaceAddViewController {
            //navigationController?.pushViewController(detailViewController, animated: true)
            addViewController.placeSavedFromChildViewController = {
                do {
                    let location = try Realm().objects(LocationElement.self).last
                    self.locationList.append(location._rlmInferWrappedType())
                    //self.tableView.reloadData()
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
    
    func deleteLocationFromDatabase(location: LocationElement, indexPath: IndexPath) {
        do {
            try Realm().write {
                try Realm().delete(location)
            }
            
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch {
            print(error)
        }
    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return locationList.count
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let location = locationList[indexPath.row]
        
        cell.cityLable.text = location.name
        
        Alamofire.request("https://api.darksky.net/forecast/0a3080e5ebc094338e3a5fb7196e390b/\(location.lat),\(location.lon)", method: .get).responseData { response in
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: value)
                    let temperatureInCelciuus = (Int) ((weather.currently.temperature - 32) * 0.56)
                    cell.temperatureLabel.text = "\(temperatureInCelciuus)°C"
                    cell.temperatureImageView.image = UIImage(named: "storm")
                } catch {
                    print(error)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "DetailWeatherViewController") as! DetailWeatherViewController
        
        let location = locationList[indexPath.row]
        detailViewController.location = location
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
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } catch {
            print(error)
        }
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
