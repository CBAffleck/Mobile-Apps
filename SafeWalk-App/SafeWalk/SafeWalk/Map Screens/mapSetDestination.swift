//
//  mapSetDestination.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/28/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient
import MapKit
import CoreLocation

class mapSetDestination: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    //MARK: Properties
    @IBOutlet weak var setDestinationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var destinationView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: Variables
    var locationManager = CLLocationManager()
    var currLocation = CLLocation()
    var userNotes = ""
    var userDate = Date()
    var meetingPoint : CLLocationCoordinate2D? = nil
    var destination : CLLocationCoordinate2D? = nil
    let halfScreenSize = UIScreen.main.bounds.height / 2
    var counter = Timer()
    var destinationSet = false
    var annotations = [MKPointAnnotation()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        infoView.isHidden = true
        closeButton.isHidden = true
        mapView.delegate = self

        //AWS Mobile Client initialization
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        //Location services
        checkLocationServices()
        
        //Init countdown timer
        counter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    //User Location Functions
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuth()
        } else {
            print("Please turn on location services.")
        }
    }
    
    //Deal with different authorizations the user gives the app for location services
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = false
            if !destinationSet {
                centerViewOnUserLocation()
            } else {
                centerViewAroundMarks()
            }
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //Show alert instructing them to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show alert to say they're restricted
            break
        case .authorizedAlways:
            break
        }
    }
    
    func centerViewAroundMarks() {
        let p1 = MKMapPoint(meetingPoint!)
        let p2 = MKMapPoint(destination!)
        let mapArea = MKMapRect(x: fmin(p1.x, p2.x), y: fmin(p1.y, p2.y), width: fabs(p1.x - p2.x), height: fabs(p1.y - p2.y))
        mapView.setVisibleMapRect(mapArea, animated: true)
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 600, longitudinalMeters: 600)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currLocation = locations.last!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let center = CLLocationCoordinate2D(latitude: self.currLocation.coordinate.latitude, longitude: self.currLocation.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
    func getCircleRadius() -> Double {
        let circleEdgePoint = CGPoint(x: (UIScreen.main.bounds.width / 2) + 100, y: UIScreen.main.bounds.height / 2)
        let cirlceOuterCoordinate = mapView.convert(circleEdgePoint, toCoordinateFrom: mapView)
        let circleOuterLocation = CLLocation(latitude: cirlceOuterCoordinate.latitude, longitude: cirlceOuterCoordinate.longitude)
        let centerLocation = CLLocation(latitude: (mapView?.centerCoordinate.latitude)!, longitude: (mapView?.centerCoordinate.longitude)!)
        let radius : CLLocationDistance = centerLocation.distance(from: circleOuterLocation)
        return radius
    }

    func openJourneyView() {
        infoView.isHidden = false
        let newHeight = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: halfScreenSize)
        mapView.addConstraint(newHeight)
//        infoViewBottomConstraint.constant = 0
        
        //Animation for sidebar
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func updateCountdown() {
        let end = userDate
        let today = Date()
        let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from:today, to:end as Date)
        var countdown = ""
        if diff.hour! < 10 {
            countdown += "0"
        }
        countdown += "\(diff.hour ?? 0):"
        if diff.minute! < 10 {
            countdown += "0"
        }
        countdown += "\(diff.minute ?? 0):"
        if diff.second! < 10 {
            countdown += "0"
        }
        countdown += "\(diff.second ?? 0)"
        countdownLabel.text = countdown
    }
    
    func addMapMarks() {
        let circle = MKCircle(center: destination!, radius: getCircleRadius())
        let circlePin = MKPointAnnotation()
        circlePin.coordinate = destination!
        mapView.addOverlay(circle)
        annotations.append(circlePin)
        
        let startPin = MKPointAnnotation()
        startPin.coordinate = meetingPoint!
        mapView.addAnnotation(startPin)
        annotations.append(startPin)
        
        
//        let randomPoint = MKPointAnnotation()
//        let a = Double.random(in: 0...1) * 2 * Double.pi
//        let r = 100 * sqrt(Double.random(in: 0...1))
//        let xpos = r * cos(a)
//        let ypos = r * sin(a)
//        let circleScreenPoint = CGPoint(x: (UIScreen.main.bounds.width / 2) + CGFloat(xpos), y: (UIScreen.main.bounds.height / 2) + CGFloat(ypos))
//        let randomCircleCoord = mapView.convert(circleScreenPoint, toCoordinateFrom: mapView)
//        randomPoint.coordinate = randomCircleCoord
//        mapView.addAnnotation(randomPoint)
    }
    
    //MARK: Actions
    @IBAction func setDestination(_ sender: UIButton) {
        destination = mapView?.centerCoordinate
        destinationSet = true
        openJourneyView()
        addMapMarks()
        destinationView.isHidden = true
        backButton.isHidden = true
        closeButton.isHidden = false
    }
    
    @IBAction func backToNotes(_ sender: UIButton) {
    }
    
    @IBAction func cancelGroupSearch(_ sender: UIButton) {
    }
}

extension mapSetDestination : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.init(displayP3Red: 75/255.00, green: 179/255.00, blue: 255/255.00, alpha: 0.2)
            return circleRenderer
        }
        return MKCircleRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MKAnnotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "Editable_pin.png")
            annotationView.centerOffset = CGPoint(x: 0, y: -annotationView.frame.size.height / 2)
            return annotationView
        }
    }
}
