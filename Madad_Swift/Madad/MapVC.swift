//
//  MapVC.swift
//  Madad
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
        
       // loadVideos()
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
     
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let addPin = MKPointAnnotation()
        addPin.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        addPin.title = "You are here"
        mapView.addAnnotation(addPin)
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
        
        var filename = "3"
        print(filename)
        
        guard let path1 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
       
        var location = VideoNotification(Path: path1, Lat: 25.3000, Lng: 51.5100)
       
        videos.append( location )
        
        
        
        filename = "4"
        print(filename)
        
        guard let path11 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        
        
        location = VideoNotification(Path: path11, Lat: 25.2950, Lng: 51.5192)
        videos.append( location )
        
        
        
        
        filename = "Thereisabombthreat"
        print(filename)
        
        guard let path5 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        

        location = VideoNotification(Path: path5, Lat: 25.3136, Lng: 51.5214)
        videos.append( location )
        
        
        filename = "9"
        print(filename)
        
        guard let path6 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        location = VideoNotification(Path: path6, Lat: 25.3137, Lng: 51.5200)
        videos.append( location )
        
        
        filename = "Pleaseleavethebuildingimmediately"
        print(filename)
        
        guard let path7 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        location = VideoNotification(Path: path7, Lat: 25.3131655, Lng: 51.5217304)
        videos.append( location )
        
        
        filename = "5"
        print(filename)
        
        guard let path8 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        location = VideoNotification(Path: path8, Lat: 25.3131000, Lng: 51.5217300)
        videos.append( location )
        
      
        
        
        
        self.mapView.addAnnotations(videos)
       
    }
    
    
    // func of loading videos from server
    public func loadVideos() {
        
        // need to modify url
        let url = URL(string: "http://\(serverhost):5000/videos")!
        
        
        var request = URLRequest(url: url)
        
        // declare method of passing information to server
        request.httpMethod = "GET"
        
        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // no error
            if error == nil {
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    
                    self.videos.removeAll(keepingCapacity: false)
                    
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    guard let parseJSON = json else {
                        print("Error while parsing")
                        return
                    }
                    
                    //////////// json file  {"videos":[RowDataPacket{"path":"","lat":"","lng":""}]}
                    guard let videos = parseJSON["videos"]  as? [AnyObject] else {
                        print("Error while parseJSONing")
                        return
                    }
                    
                    self.videos = videos
                   
                    for i in 0 ..< self.videos.count {
                        
                        let  Path = self.videos[i]["path"] as? String
                        let  Lat = self.videos[i]["lat"] as! Double;
                        let   Lng = self.videos[i]["lng"] as!  Double;
                      
                        
                        
                        if let  Path = Path
                            {
                            
                            let currentPost =  VideoNotification(Path: Path, Lat: Lat, Lng: Lng)
                            
                            
                            self.videoMap.append( currentPost )
                            
                        }
                        
                        
                        self.mapView.addAnnotations(self.videoMap)
                        
                        
                    }
                    
                    
                } catch {
                    print("error:\(error)")
                }
                
            }
            
            }.resume()
        
    }
    
    
   
}
