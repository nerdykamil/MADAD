//
//  MapVC.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import UIKit
import MapKit
class MapVC: UIViewController, MKMapViewDelegate, VideoMapViewDelegate {
   
    
    var videoMap: [VideoNotification] = []
    var videos = [AnyObject]()
    
   
 
    @IBOutlet weak var mapView: MKMapView!
    
  var selectedVideo: VideoNotification?
    
    private let videoAnnotationName = "videoAnnotationName"
  
  
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
           
     initializeVideos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
     
        
        let addPin = MKPointAnnotation()
        addPin.coordinate = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        addPin.title = "You are here"
        mapView.addAnnotation(annotation)
        
    }
    
 
    
    
    
    
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdvc = segue.destination as? ExpandedVideoVC {
            pdvc.video = self.selectedVideo
            
        }
    }
    
    func detailsRequestedForVideo(video: VideoNotification) {
        self.selectedVideo = video
        self.performSegue(withIdentifier: "videoExpanded", sender: nil)
    }
    
    
    
    func ifNewNotification(){
      
        if let annotation = (mapView.annotations ).first {
            selectPinPointInTheMap(annotation: annotation)
        }
    }
    
   
    
    func selectPinPointInTheMap(annotation: MKAnnotation ) {
        mapView.selectAnnotation(annotation, animated: true)
        if CLLocationCoordinate2DIsValid(annotation.coordinate) {
            self.mapView.setCenter(annotation.coordinate, animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
       /* let visibleRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        let addPin = MKPointAnnotation()
        addPin.coordinate = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        addPin.title = "You are here"
        mapView.addAnnotation(annotation)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)*/
        
        
        
        //if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let addPin = MKPointAnnotation()
        addPin.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        addPin.title = "You are here"
        mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: videoAnnotationName)
        
        if annotationView == nil {
            annotationView = VideoAnnotationView(annotation: annotation, reuseIdentifier: videoAnnotationName)
            (annotationView as! VideoAnnotationView).videoConfigureDelegate = self
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    

    
    
    func initializeVideos()  {
      
        var videos = [VideoNotification]()
        self.videos.removeAll(keepingCapacity: false)
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        var filename = "IneedHelp"
        print(filename)
        
        guard let path1 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        ///// videos
        //var path = "http://\(localhost):5000/videos/0.mp4"
        var location = VideoNotification(Path: path1, Lat: 25.322508, Lng: 51.528355)
       
        videos.append( location )
        
        
        filename = "IneedHelp"
        print(filename)
        
        guard let path2 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
         location = VideoNotification(Path: path2, Lat: 25.2608759, Lng: 51.616025)
        videos.append( location )
        
        
        filename = "Pleaseleavethebuildingimmediately"
        print(filename)
        
        guard let path3 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
       location = VideoNotification(Path: path3, Lat: 25.2543318, Lng: 51.5659578)
        videos.append( location )
        
        filename = "PleaseSitDown"
        print(filename)
        
        guard let path4 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        
        
        location = VideoNotification(Path: path4, Lat: 25.3220815, Lng: 51.4395895)
        videos.append( location )
        
        filename = "Thereisabombthreat"
        print(filename)
        
        guard let path5 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        

        location = VideoNotification(Path: path5, Lat: 25.3133482, Lng: 51.5214587)
        videos.append( location )
        
        
        
        
        self.mapView.addAnnotations(videos)
       
    }
    
   
}










