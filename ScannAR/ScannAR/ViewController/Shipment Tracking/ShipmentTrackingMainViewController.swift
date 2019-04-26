//
//  ShipmentTrackingMainViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/18/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ShipmentTrackingMainViewController: UIViewController, MapDrawerDelegate, UIAdaptivePresentationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var shipmentMapView: MKMapView!
    @IBOutlet weak var closeButton: UIButton!
    var scannARNetworkingController: ScannARNetworkController?
    var shipment: Shipment?
//    var model: MockShipmentModel?
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        print("button tapped")
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        shipmentMapView.delegate = self
        addAnnotation()
        centerMapOnLocation(location: initialLocation)
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapDrawerViewController{
            vc.mapDrawerDelegate = self
            vc.parentView = container
            vc.scannARNetworkingController = scannARNetworkingController
            vc.shipment = shipment
        }
    }
    
    func updateMapDrawer(frame: CGRect) {
        container.frame = frame.insetBy(dx: 16, dy: 0)
    }
    
    // MARK: - Private Methods
    
    private func addAnnotation() {
//        let address = model?.shippedTo
        guard let address = shipment?.shippedTo else { return }
        let geocoder = CLGeocoder()
        let destination = MKPointAnnotation()
        destination.title = address
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                NSLog("Error: \(error!)")
            }
            if let placemark = placemarks?.first {
                destination.coordinate = placemark.location!.coordinate
                self.centerMapOnLocation(location: placemark.location!)
            }
        })
        
        DispatchQueue.main.async {
            self.shipmentMapView.addAnnotation(destination)
        }
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        shipmentMapView.setRegion(coordinateRegion, animated: true)
    }
   
    // MARK: - MapViewDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last as CLLocation? else { return }
        
        let userCenter = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // Does not have to be userCenter, could replace latitude: and longitude: with any value you would like to center in on
        
        let region = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        DispatchQueue.main.async {
            self.shipmentMapView.setRegion(region, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            DispatchQueue.main.async {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            }
            
        } else {
            DispatchQueue.main.async {
                annotationView!.annotation = annotation
            }
        }
        
        return annotationView
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.overCurrentContext
    }
}


