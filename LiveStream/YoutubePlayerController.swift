//
//  ViewController.swift
//  LiveStream
//
//  Created by ibrahim on 9/28/16.
//  Copyright © 2016 Indosytem. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!

    var videoID = String()
    @IBOutlet weak var jsonRestText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // play video using youtube helper player with provided youtube video id
        self.playerView.load(withVideoId: videoID)
        
        // Set up your URL to get video information detail
        let youtubeApi = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+statistics&id=\(videoID)&key=AIzaSyCX7_A4aWoTu8WQRLUg3VtLzsighlggv4M"
        
        let url = URL(string: youtubeApi)
        
        performGetRequest(targetURL: url){ result in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: result.0! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    
                    self.jsonRestText.text = "Response from YouTube: \(jsonResult)"
                }
            }
            catch {
                print("json error: \(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // perform Get Request to url provided
    func performGetRequest(targetURL: URL!, completion: @escaping (_ data: NSData?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: targetURL as URL)
        request.httpMethod = "GET"
        
        // Create your request
        let task = URLSession.shared.dataTask(with: targetURL! as URL, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data as NSData?, (response as! HTTPURLResponse).statusCode, error as NSError?)
            })
            
        })
        
        
        task.resume()
    }
}

