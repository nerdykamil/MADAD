//
//  PostCallout.swift
//
//
//  Created by Hagar Hussein 
//  Copyright © 2019 Qatar. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
class VideoCallout: UIView {
    
    @IBOutlet var backgroundButton: UIButton!
    @IBOutlet var expandButton: UIButton!
    
    var video: VideoNotification!
    
     weak var delegate: VideoMapViewDelegate?
    
    @IBOutlet var videoPlayer: VideoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       

    
        backgroundButton.ArrowDialogOrientation(arrowOrientation: .down)
    }
 
    
    func stopVideo(){
        self.videoPlayer.stop()
    }
    func playVideo(urlString: String){
        
        self.videoPlayer.configure(url: urlString)
        self.videoPlayer.loop = true
        self.videoPlayer.play()
    }
    
    
    func pause(){
        
       
        self.videoPlayer.pause()
       
    }
    
    
    func configureVideo(video: VideoNotification) {
        self.video = video
    
        
    }
    
    
   // Check if it hit post annotation view components.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
      
        if let result = expandButton.hitTest(convert(point, to:expandButton), with: event) {
            return result
        }
     
      
        return backgroundButton.hitTest(convert(point, to: backgroundButton), with: event)
    }
    
    @IBAction func expand(_ sender: Any) {
          self.stopVideo()
        delegate?.detailsRequestedForVideo(video: self.video)
    }
    
   
}


protocol VideoMapViewDelegate: class {
    func detailsRequestedForVideo(video:VideoNotification)
}
