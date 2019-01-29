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
    
    //MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Actions
    @IBAction func setDestination(_ sender: UIButton) {
    }
    
    @IBAction func backToNotes(_ sender: UIButton) {
    }
}
