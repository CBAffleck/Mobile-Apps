//
//  mapHomeScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/23/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient
import MapKit
import CoreLocation

class MapHomeScreen: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var setMeetingPointButton: UIButton!
    @IBOutlet weak var sidebarButton: UIButton!
    @IBOutlet weak var leadingMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideSidebarButton: UIButton!
    @IBOutlet weak var sidebar: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var groupsButton: UIButton!
    @IBOutlet weak var filtersButton: UIButton!
    @IBOutlet weak var blacklistButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    //MARK: Variables
    var locationManager = CLLocationManager()
    var currLocation = CLLocation()
    var menuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        
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
        
        //Sidebar
        hideSidebarButton.isHidden = true
        hideSidebarButton.isEnabled = false
        hideSidebarButton.alpha = 0.0
        sidebar.isHidden = true
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
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
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
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindSlideUpSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is mapTimeNotes {
            let view = segue.destination as? mapTimeNotes
            view?.meetingPoint = mapView?.centerCoordinate
        }
    }
    
    //MARK: Actions
    @IBAction func setMeetingPoint(_ sender: UIButton) {
    }
    
    @IBAction func openSidebar(_ sender: UIButton) {
        sidebar.isHidden = false
        leadingMenuConstraint.constant = 0
        hideSidebarButton.isHidden = false
        hideSidebarButton.isEnabled = true
        
        //Animation for sidebar
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.hideSidebarButton.alpha = 1.0
        })
    }
    
    @IBAction func hideSidebar(_ sender: UIButton) {
        leadingMenuConstraint.constant = -221
        hideSidebarButton.isHidden = true
        hideSidebarButton.isEnabled = false
        
        //Animation for sidebar
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.hideSidebarButton.alpha = 0.0
        })
    }
    
    @IBAction func toProfile(_ sender: UIButton) {
    }
    
    @IBAction func toGroups(_ sender: UIButton) {
    }
    
    @IBAction func toFilters(_ sender: UIButton) {
    }
    
    @IBAction func toBlacklist(_ sender: UIButton) {
    }
    
    @IBAction func toHelp(_ sender: UIButton) {
    }
    
    @IBAction func toSignInScreen(_ sender: UIButton) {
        AWSMobileClient.sharedInstance().signOut()
    }
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue) {
        
    }
    
}
