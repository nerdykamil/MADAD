//
//  SOSViewController.swift
//  Madad
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import UIKit

class SOSViewController: UIViewController {
    var currentLat :Double!
    var currentLong:Double!
    
    @IBOutlet var videoPlayer: VideoView!
    
    @IBOutlet var videoImage: UIImageView!
    
    var textAlert = String()
    var filename = String()
    ///video view
    
    /// buttons with related videos play in video view
    
    /// buttins send to server with text
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let filename = "instruction"
        guard let path1 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint(filename)
            return
        }
        
        playVideo(urlString: path1 )
       
    }

    @objc func bodyParametersSetter(_ parameters: [String: Any]?) -> Data {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
      
                body.appendString("\(key)=\(value)")
                body.appendString("&")
            }
        }

        return body as Data
        
    }

    @objc func sendAlert(text:String) {
    
        // url to post
        let url = URL(string: "http://\(serverhost):5001/storesos")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
         if let lm = appDelegate.locationManager.location{
        currentLat = lm.coordinate.latitude
        currentLong = lm.coordinate.longitude
       }
         else{
            currentLat = 0
            currentLong = 0
            
        }
        
       
        /*let param = [
            
            "sos_msg" : text,
            "lat": currentLat!,
            "lon": currentLong!
            ] as [String : Any]*/
 
        
        let body = "sos_msg=\(text)&lat=\(currentLat!)&lon=\(currentLong!)"
        print(body)
        
        // append body to the request
        request.httpBody = body.data(using: .utf8)
        //request.httpBody = bodyParametersSetter(param)
        
        
  
        URLSession.shared.dataTask(with: request) { data, response, error in
            
             

            DispatchQueue.main.async(execute: {
                
                
                if error == nil {
                    
                    do {

                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                    
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }

                        let response = parseJSON["response"]
                    
                        if response != nil {
                            
                            
                
                            
                            // if sent
                            
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
    
    
    
    @IBAction func playVideoOnScreen(_ sender: AnyObject) {
        
        
        if(videoPlayer.isPlaying()){
              stopVideo()
         videoImage.isHidden = false
        }
        videoImage.isHidden = true
        
        
        print(filename)
      
        let selected = sender.tag
        print(selected as Any )
        
        if(selected == 0){
            ///// 0 = fire
           
          filename = "ThereisFireIneedhelp"
           
        }
        else if(selected == 1){
            ///// 1 = crowd
        filename = "IneedHelp"
        }
            
            
        else if(selected == 2){
            ///// 2 = transportation
            filename = "Planeleavesat9AM"
        }
            
        else if(selected == 3){
            ///// 3 = vielonce
            filename = "Thereisabombthreat"
        }
            
        else if(selected == 4){
            ///// 4 = more
            
           filename = "IneedHelp"
        }
        
        
        
        
        guard let path1 = Bundle.main.path(forResource: filename, ofType:"mp4") else {
            debugPrint(filename)
            return
        }
    
        playVideo(urlString: path1 )
        
        
    }
    
    
    @IBAction func sendTextAlertFunc(_ sender: AnyObject) {
        
        
        let selected = sender.tag
        print(selected as Any )
        
        if(selected == 0){
            ///// 0 = fire
            textAlert = "fire"
        }
        else if(selected == 1){
            ///// 1 = crowd
            textAlert = "crowd"
        }
        
        
        else if(selected == 2){
            ///// 2 = transportation
            textAlert = "transportation"
        }
        
        else if(selected == 3){
            ///// 3 = vielonce
            textAlert = "vielonce"
        }
        
        else if(selected == 4){
            ///// 4 = more
            
            textAlert = "more"
        }
        
        
        print( textAlert  )
        
        sendAlert(text:textAlert)
   
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

    

