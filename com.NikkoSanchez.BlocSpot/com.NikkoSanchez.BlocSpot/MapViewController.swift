//
//  ViewController.swift
//  com.NikkoSanchez.BlocSpot
//
//  Created by Nikko on 10/27/16.
//  Copyright © 2016 Nikko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController : UISearchController?
    
    var locationManager = CLLocationManager()
    var latitudeLoc : Double = 0
    var longitudeLoc : Double = 0
    var annotationArray = [MapAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let searchTable = storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        resultSearchController = UISearchController(searchResultsController: searchTable)
        resultSearchController?.searchResultsUpdater = searchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        navigationItem.titleView = resultSearchController?.searchBar
        
        searchBar.placeholder = "Search For Places"
        
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        resultSearchController?.searchBar.delegate = self
        definesPresentationContext = true
        
        searchTable.mapView = mapView
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // Ask for user locaiton permission
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        guard let locValue : CLLocationCoordinate2D = locations.last?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if locValue.latitude != latitudeLoc || locValue.longitude != longitudeLoc {
            latitudeLoc = locValue.latitude
            longitudeLoc = locValue.longitude
            // update mapRegion
            let rgn = MKCoordinateRegionMakeWithDistance(
                CLLocationCoordinate2DMake(latitudeLoc, longitudeLoc), 3500, 3500)
            mapView.setRegion(rgn, animated: true)
            searchMap()
        }
        
    }
    // MARK: MKLocalSearch/Request
    
    func searchMap() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = resultSearchController?.searchBar.text//"Pizza"
        request.region = mapView.region
        
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                print("search error: error")
                return
            }
            
            for item in response.mapItems {
                //print("Item name = \(item.name)")
                self.addPinToMapView(title: item.name!, latitude: (item.placemark.location?.coordinate.latitude)!, longitude: (item.placemark.location?.coordinate.longitude)!)
            }
        }
        
    }
    
    // Add annotation to map view
    
    func addPinToMapView(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MapAnnotation(coordinate: location, title: title)
        
        mapView.addAnnotation(annotation)
        annotationArray.append(annotation)
    }
    
    // MARK: Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fillListView" {
            let controller = segue.destination as! ListTableViewController
            controller.listArray = annotationArray
            controller.delegate = self
        }
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
    
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomPinAnnotationView")
        pinView.pinTintColor = UIColor.red
        pinView.canShowCallout = true
    
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let annotations = mapView.annotations
        annotationArray.removeAll()
        
        // filter annotations for those that are inside the current region
        //let filteredAnnotations = annotationArray // do some filtering here
        
        mapView.removeAnnotations(annotations)
        
      //  mapView.addAnnotations(filteredAnnotations)
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        searchMap()
    }
}

extension MapViewController: ListTableViewControllerDelegate {
    
    func centerOn(annotation: MKAnnotation) {
        let rgn = MKCoordinateRegionMakeWithDistance(
            CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude), 3500, 3500)
        mapView.setRegion(rgn, animated: true)
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        //print("YOOOOOO")
    }

}
