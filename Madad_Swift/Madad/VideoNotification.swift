//
//  VideoNotification.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import Foundation
import MapKit
class VideoNotification: NSObject, MKAnnotation {
    
  
    var  Path: String;
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    var  Lat: Double;
    var   Lng: Double;
    
    init(Path: String, Lat: Double ,
         Lng: Double){
    
        self.Path = Path
        self.Lat = Lat
        self.Lng = Lng
        self.coordinate = CLLocationCoordinate2D(latitude: Lat, longitude: Lng)
        super.init()
    };
    
    
    
    var subtitle: String? {
        return "test"
    }
    
    
    
    
    
    
    
    
}


