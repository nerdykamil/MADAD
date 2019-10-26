//
//  ExpandedVideoVC.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import UIKit

class ExpandedVideoVC: UIViewController {
    
    var initialPoint: CGPoint = CGPoint(x: 0,y: 0)
    var video: VideoNotification?
    @IBOutlet var videoPlayer: VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if video != nil {
          self.playVideo(urlString: video!.Path) }
        }

    /// dismiss screen when swipe down
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    func playVideo(urlString: String){
        
        self.videoPlayer.configure(url: urlString)
        self.videoPlayer.loop = true
        self.videoPlayer.play()
    }
    
    func stopVideo(){
        self.videoPlayer.stop()
    }
    

    
}
