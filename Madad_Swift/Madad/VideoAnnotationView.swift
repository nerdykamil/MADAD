//
//  PostAnnotationView.swift
//
//
//  Created by Hagar Hussein
//  Copyright © 2019 Qatar. All rights reserved.
//

import Foundation
import MapKit

class VideoAnnotationView: MKAnnotationView {
    
    private let PinImage = UIImage(named: "pinMarker")!
    private let MapAnimationTime = 0.250
    
    weak var videoCallout: VideoCallout?
  
    override var annotation: MKAnnotation? {
        willSet { videoCallout?.removeFromSuperview() }
    }
      weak var videoConfigureDelegate: VideoMapViewDelegate?
   
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = PinImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        self.image = PinImage
    }
    
    // If callout is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.videoCallout?.removeFromSuperview()
            
            if let customCallout = loadCofigueredView() {
              
                customCallout.frame.origin.x -= customCallout.frame.width / 2.0 - (self.frame.width / 2.0)
                customCallout.frame.origin.y -= customCallout.frame.height
                
                
                self.addSubview(customCallout)
                self.videoCallout = customCallout
                
                
                if animated {
                    self.videoCallout!.alpha = 0.0
                    UIView.animate(withDuration: MapAnimationTime, animations: {
                        self.videoCallout!.alpha = 1.0
                    })
                }
            }
        } else {
            if videoCallout != nil {
                if animated {
                    UIView.animate(withDuration: MapAnimationTime, animations: {
                        self.videoCallout!.alpha = 0.1
                    }, completion: { (success) in
                        if self.videoCallout != nil{
                            self.videoCallout!.removeFromSuperview()}
                    })
                } else { self.videoCallout!.removeFromSuperview() }
            }
        }
    }

 
    func loadCofigueredView() -> VideoCallout? {
        if let views = Bundle.main.loadNibNamed("VideoCallout", owner: self, options: nil) as? [VideoCallout], views.count > 0 {
            let vDetailMapView = views.first!
            vDetailMapView.delegate = self.videoConfigureDelegate
            if let vAnnotation = annotation as? VideoNotification {
                vDetailMapView.configureVideo(video:
                    vAnnotation)
               
                    vDetailMapView.playVideo(urlString: vAnnotation.Path)}

            return vDetailMapView
        }
        return nil
    }

    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoCallout?.removeFromSuperview()
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
     
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else {
            if videoCallout != nil {
                return videoCallout!.hitTest(convert(point, to:videoCallout!), with: event)
            } else { return nil }
        }
    }
    
}
