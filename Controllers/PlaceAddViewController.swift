//
//  PlaceAddViewController.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 11/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PlaceAddViewController: UIViewController {
    
    //Loading indicator
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
    var locationList = [LocationElement]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var placeSavedFromChildViewController: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Loading indicator start //
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        // Loading indicator end //
    }
    
    func getPlaceNamesFromServer(name: String) {
        present(alert, animated: true, completion: nil) //loading indicator
        
        let parameters: Parameters = ["q": name, "format": "json", "pretty": 1, "key": Constant.API_APUX]
        let baseUrl = "https://api.apixu.com/v1/search.json"
        
        Alamofire.request(baseUrl, method: .get, parameters: parameters).responseData { response in
            if response.result.isFailure, let error = response.result.error {
                print(error)
                self.hideLoadingView()
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let location = try JSONDecoder().decode([LocationElement].self, from: value)
                    self.locationList = location
                    self.tableView.reloadData()
                    self.hideLoadingView()
                } catch {
                    print(error)
                    self.hideLoadingView()
                }
            }
        }
    }
    
    func saveLocation(location: LocationElement) {
        
        do {
            if realm.objects(LocationElement.self).filter("id = \(location.id)").first != nil {
                
                let errorAlert = UIAlertController(title: "Error!", message: "This location is already exist in your saved location", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                errorAlert.addAction(cancelAction)
                present(errorAlert, animated: true)
                
            }else {
                try realm.write {
                    realm.add(location)
                }
                
                placeSavedFromChildViewController?()
                dismiss(animated: true, completion: nil)
            }
            
        } catch {
            print(error)
        }
        
    }
    
    
    internal func hideLoadingView() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension PlaceAddViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 0 > 0, let text = searchBar.text {
            getPlaceNamesFromServer(name: text)
        }
        
    }
}


extension PlaceAddViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.cityLable.text = locationList[indexPath.row].name
        cell.temperatureLabel.text = locationList[indexPath.row].region
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locationList[indexPath.row]
        
        saveLocation(location: location)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
