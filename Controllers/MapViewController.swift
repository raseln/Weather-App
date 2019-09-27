//
//  MapViewController.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 19/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    let regionInMeter: Double = 100000
    var locationName = "My Current Location"
    var locationWeather = "30℃"
    var locationList = [LocationElement]()
    var weatherList = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //mapView.showsUserLocation = true
            //centerViewOnUserLocation()
            //addMarker()
            addMultipleMarker()
            locationManager.startUpdatingLocation()
            
        case .denied:
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            break
            
        default:
            print("Default")
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //setup
            setupLocationManager()
            checkLocationAuthorization()
        }else {
            let alert = UIAlertController(title: "Alert!", message: "Location service is disabled! Please goto settings and enable location", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(cancelButton)
            present(alert, animated: true)
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }else {
            let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: locationList.first?.lat ?? 23.719999, longitude: locationList.first?.lon ?? 90.409999), latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addMarker() {
        if let location = locationManager.location?.coordinate {
            let centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = locationName
            annotation.subtitle = locationWeather
            mapView.addAnnotation(annotation)
            //centerViewOnUserLocation()
        }
    }
    
    
    func addMultipleMarker() {
        for location in locationList {
            let centerCoordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            let localAnnotation = MKPointAnnotation()
            localAnnotation.coordinate = centerCoordinate
            localAnnotation.title = location.name
            localAnnotation.subtitle = locationWeather
            mapView.addAnnotation(annotation)
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationList.first?.lat ?? 23.719999, longitude: locationList.first?.lon ?? 90.409999), span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        mapView.setRegion(region, animated: true)
        annotation.coordinate = center
        annotation.title = locationName
        annotation.subtitle = locationWeather
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        if let annotationView = annotationView {
            if let icon = weatherList.first?.currently.icon {
                annotationView.image = IconHelper.getIcon(icon: icon)
            }else {
                annotationView.image = UIImage(named: "cloudy")
            }
        }
        
        
        return annotationView
    }
}
