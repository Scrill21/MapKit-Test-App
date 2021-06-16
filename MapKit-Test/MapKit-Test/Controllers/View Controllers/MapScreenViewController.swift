//
//  MapScreenViewController.swift
//  MapKit-Test
//
//  Created by anthony byrd on 6/15/21.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel

class MapScreenViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        searchVC.delegate = self
        checkLocationServices()
        cardPanel()
    }
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    let panel = FloatingPanelController()
    let regionInMeters: Double = 1000
    let searchVC = SearchViewController()
    
    //MARK: - Actions
    
    //MARK: - Methods
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            
        } else {
            //AnthonyByrd - show alert letting the user know to enable location services
            
        }
    }//End of func
    
    func cardPanel() {
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
    }
}//End of class

//MARK: - Extensions
extension MapScreenViewController: MKMapViewDelegate {
    
}

extension MapScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //AnthonyByrd - Update users location
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //AnthonyByrd - Prompt the user to give authorization
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //Show an alert letting the user know what's up
            break
        case .denied:
            //Show an alert instructing the user how to turn on permissions
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        default:
            print("unknown")
            break
        }
    }
}

extension MapScreenViewController: SearchViewControllerDelegate {
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        mapView.removeAnnotations(mapView.annotations)
        
        guard let coordinates = coordinates else { return }
        panel.move(to: .tip, animated: true)
        let newPin = MKPointAnnotation()
        newPin.coordinate = coordinates
        
        mapView.addAnnotation(newPin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.8)), animated: true)
    }
}
