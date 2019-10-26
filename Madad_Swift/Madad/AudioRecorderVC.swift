//
//  AudioRecorderVC.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderVC: UIViewController,AVAudioPlayerDelegate {
    
    var videoLink: String?
   
    
    @IBOutlet var videoImage: UIImageView!
    @IBOutlet var startButton: UIButton!
    var timeTimer: Timer!
    @IBOutlet var postButton: UIButton!
 
  @IBOutlet var videoPlayer: VideoView!
    let audioRecorder = AudioRecorder()
    var recordedFileURL: URL!

    var currentLat :Double!
    var currentLong:Double!
    @IBOutlet var timer: UILabel!
    var filename = String()
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // videoImage.isHidden=true
       
        startButton.isHidden=false
        postButton.isEnabled = false
        postButton.alpha = 0.4
       
        
      
    }
    func playVideo(urlString: String){
        
        self.videoPlayer.configure(url: urlString)
        self.videoPlayer.loop = false
        self.videoPlayer.play()
    }
    
    func stopVideo(){
        self.videoPlayer.stop()
    }
    
   
    
    @IBAction func postToServer(_ sender: Any) {
       
        
        print(audioRecorder.finishRecording())
        timer.text = "00:00"
        startButton.isEnabled=true
        postButton.isEnabled = false
        postButton.alpha = 0.4
        startButton.alpha = 1.0
        timer.isHidden = true
        
        sendPostRequest()
    }
 
    
 
    @IBAction func startRecording(_ sender: Any) {
        
        startButton.isEnabled = false
        postButton.isEnabled = true
        postButton.alpha = 1.0
        startButton.alpha = 0.4
        timer.isHidden=false
      

        let filename = "filename.wav"
    
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
       
        recordedFileURL = URL(string: ("file://"+dirPath+"/"+filename))
        print("url of recordeing file:>>>"+recordedFileURL.absoluteString)
        
        audioRecorder.record(fileName: filename)
        
        timeTimer =  Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateTimer(Timer:)), userInfo:nil, repeats:true)
        
        
        
        
        
    }
    
    
    @objc func updateTimer(Timer: Timer){
        if(audioRecorder.getRecorder().isRecording){
            
            let min = Int(audioRecorder.getRecorder().currentTime / 60)
            let sec = Int(audioRecorder.getRecorder().currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            
            
            timer.text = totalTimeString
            
            audioRecorder.getRecorder().updateMeters()
        }
        
    }
    
    

    @objc func bodyParametersSetter(_ parameters: [String: Any]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        filename = "filename.wav"
        let mimetype = "audio/wav"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        
        return body as Data
        
    }
    
    
    @objc func sendPostRequest() {
 
        
        if(videoPlayer.isPlaying()){
            stopVideo()
            videoImage.isHidden = false
        }
       
        let url = URL(string: "http://\(serverhost):5000/uploadajax")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        if let lm = appDelegate.locationManager.location{
            currentLat = lm.coordinate.latitude
            currentLong = lm.coordinate.longitude}
            
        else {
            currentLat = 0
            currentLong = 0
        }
        

        let param = [
            "Lat": currentLat!,
            "Lng": currentLong!
            ] as [String : Any]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
        
        let recording = try! Data(contentsOf: recordedFileURL )
        
        // ... body
        request.httpBody = bodyParametersSetter(param, filePathKey: "audio_data", imageDataKey: recording as! Data, boundary: boundary)

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async(execute: {
                
                
                if error == nil {
                    
                    do {
                        
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        
                        let message = parseJSON["message"]
                         print("The message is\(message)")
                     
                        if message != nil {
                            
                            self.videoImage.isHidden = true
                           
                            let filename = message! as! String
                          
                           
                            guard let videoLink = Bundle.main.path(forResource: filename , ofType:"mp4") else {
                                debugPrint("video.mp4 not found")
                                return
                            }
                           // self.videoLink =  "http://\(localhost):5000/videos/\(message!).mp4"
                            
                            print(videoLink)
                            self.postButton.isEnabled = true
                            self.postButton.alpha = 0.4
                        
                                self.playVideo(urlString: videoLink)
                            
                           
                            
                            
                        }
                        
                    } catch {
                    DispatchQueue.main.async(execute: {
                            let message = "\(error)"
                            print(message)
                        })
                        return
                        
                    }
                    
                } else {
                    
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        print(message)
                    })
                    return
                    
                }
                
                
            })
            
            }.resume()
        
    }
    
    
    
    
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
