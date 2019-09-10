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
    
    //Loading indicator
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    let myKey = "eZHhByIZccV16qn8Mix0XSgswP6525AL"
    let googlePlace = "AIzaSyA_8NSxlCCCZ9uY3Pacx3XmE6RDQmPF5xc"
    let apuxKey = "d076b7c682634184b1282949190909"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //var location = LocationElement(id: 1, name: "Dhaka", region: "DHK", lat: 22.896734, lon: 91.847644)
    var location = [LocationElement]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Loading indicator start //
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        //present(alert, animated: true, completion: nil)
        // Loading indicator end //
    }
    
    func getPlaceList(place: LocationElement) {
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
//        try realm.write {
//            realm.add(place)
//        }
    }

    func getPlaceNamesFromServer(name: String) {
        present(alert, animated: true, completion: nil) //loading indicator
        
        let parameters: Parameters = ["q": name, "format": "json", "pretty": 1, "key": apuxKey]
        let baseUrl = "https://api.apixu.com/v1/search.json"
        
        Alamofire.request(baseUrl, method: .get, parameters: parameters).responseData { response in
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let location = try JSONDecoder().decode([LocationElement].self, from: value)
                    self.location = location
                    self.tableView.reloadData()
                    self.hideLoadingView()
                } catch {
                    print(error)
                    self.hideLoadingView()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 0 > 0, let text = searchBar.text {
            getPlaceNamesFromServer(name: text)
        }
        
    }
    
    internal func hideLoadingView() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            dismiss(animated: true, completion: nil)
        }
    }

}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.cityLable.text = location[indexPath.row].name
        cell.temperatureLabel.text = location[indexPath.row].region
        
        return cell
    }
    
}
