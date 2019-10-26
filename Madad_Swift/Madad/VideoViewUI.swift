//
//  VideoViewUI.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var loop: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    
    func isPlaying() ->Bool {
        if player != nil {
           return true
        }
        
        else {return false}
        
    }
    
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    func configure(url: String) {
        let videoURL = URL(fileURLWithPath: url)
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity =  AVLayerVideoGravity.resizeAspectFill
            if let playerLayer = self.playerLayer {
                layer.addSublayer(playerLayer)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if loop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
    
   
}

