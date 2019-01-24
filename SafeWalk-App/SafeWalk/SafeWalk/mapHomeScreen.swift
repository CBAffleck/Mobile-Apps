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

class MapHomeScreen: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
        
        //AWS Mobile Client initialization
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        //Map initialization
        let initialLocation = CLLocation(latitude: 37.86946, longitude: -122.25512)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: false)
        }
        centerMapOnLocation(location: initialLocation)
    }
    
    //MARK: Actions
    
}
