//
//  SubmitYoutubeVideoIDController.swift
//  LiveStream
//
//  Created by ibrahim on 9/28/16.
//  Copyright © 2016 Indosytem. All rights reserved.
//

import UIKit

class SubmitYoutubeVideoIDController: UIViewController {

    @IBOutlet weak var videoIDField: UITextField!
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "submitVideoID"{
            if videoIDField.text! == "" {
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitVideoID"{
            let destController : YoutubePlayerController = segue.destination as! YoutubePlayerController

            destController.videoID = videoIDField.text!  
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
