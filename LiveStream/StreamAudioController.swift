//
//  StreamAudioController.swift
//  LiveStream
//
//  Created by ibrahim on 9/28/16.
//  Copyright © 2016 Indosytem. All rights reserved.
//

import UIKit
import AVFoundation

class StreamAudioController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    var timerSchedule  = Timer()
    var sliderSchedule = Timer()
    
    @IBOutlet weak var remainingPlayTIme: UILabel!
    @IBOutlet weak var currentPlayTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timerSchedule  = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StreamAudioController.updateTime), userInfo: nil, repeats: true)
        
        sliderSchedule = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StreamAudioController.updateSlider), userInfo: nil, repeats: true)
        
        let url = NSURL(string: "https://s3.amazonaws.com/kargopolov/BlueCafe.mp3")
        playerItem = AVPlayerItem(url: url! as URL)
        player=AVPlayer(playerItem: playerItem!)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        self.view.layer.addSublayer(playerLayer)
    
        slider.maximumValue = Float( CMTimeGetSeconds((player?.currentItem?.asset.duration)!)  )
    }
    
    func updateTime(){
        let currentTime = Int( CMTimeGetSeconds((player?.currentTime())!) )
        let duration = Int( CMTimeGetSeconds((player?.currentItem?.asset.duration)!)  )
        
//        if currentTime > duration {
//           timerSchedule.invalidate()
//           sliderSchedule.invalidate()
//            
//            return;
//        }
        
        print(currentTime)
        print(duration)
        
        var minutes = currentTime/60
        var seconds = currentTime % 60
        
        currentPlayTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
        let remainingTime = duration - currentTime
        minutes = remainingTime/60
        seconds = remainingTime % 60
        
        remainingPlayTIme.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    func updateSlider(){
        slider.value = Float( CMTimeGetSeconds( (player?.currentTime())! ) )
    }
    
    @IBAction func sliderChange(_ sender: AnyObject) {
        player?.pause()
        let preferredTimeScale:Int32 = 1
        let playerTime = CMTimeMakeWithSeconds(Float64(slider.value),preferredTimeScale)
        
        player?.seek(to: playerTime)
        player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:  #selector(StreamAudioController.finishedPlaying), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        // check player play back rate
        if player?.rate == 0
        {
            // play audio files
            player!.play()
            updateTime()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState.normal)
        } else {
            // pause audio files
            player!.pause()
            updateTime()
            playButton.setImage(UIImage(named: "play"), for: UIControlState.normal)
        }
    }
    
    func finishedPlaying(myNotification : NSNotification) {
        player?.pause()
        
        playButton.setImage(UIImage(named: "play"), for: UIControlState.normal)
        player?.seek(to: kCMTimeZero)
        slider.value = 0
        
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
