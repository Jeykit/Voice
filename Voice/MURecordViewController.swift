//
//  MURecordViewController.swift
//  Voice
//
//  Created by Adaman on 4/13/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

import UIKit

import AVFoundation

class MURecordViewController: UIViewController,AVAudioRecorderDelegate {

    //whether it is stsrting up
    private var isRecording:Bool = false
    
    //whether "palybackButton" by clicked
    private var isPlaying:Bool = false
    
    //define a timer
    private var timer:NSTimer?
    
    //define a audioPlayer object
    private var audioPlayer:AVAudioPlayer?
    
    //define a recorder
    private var recorder:AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "audioRecorder"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(18.0),NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        let rightBarItem = UIBarButtonItem(title: "Playback", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MURecordViewController.handlerRightBarItem(_:)))
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.customButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    func handlerRightBarItem(barItem : UIBarButtonItem) {
        
        if self.isPlaying {
            
            self.audioPlayer?.pause()
            
            self.isPlaying = false
        }else{
            
            if (self.recorder != nil) {
                
                do{
                    
                    self.audioPlayer = try AVAudioPlayer(contentsOfURL: self.recorder!.url)
                    
                }catch {
                    
                }
                
                self.audioPlayer?.volume = 1.0
                
                audioPlayer?.prepareToPlay()
                
                self.audioPlayer?.play()
                
                self.isPlaying = true
                
            }else{
                
                self.alertView("You are not record audio")
            }
        }
        
    }
    
    private func customButton() {
        
        let width:CGFloat = 120.0
        
        let spacingVertical = self.view.frame.height * 0.38
        
        let spacingHorizontal = (self.view.frame.width - 120.0)/2.0
        
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Start", forState: UIControlState.Normal)
        
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        button.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        
        //setting round button
        button.layer.cornerRadius = 60.0
        
        button.layer.masksToBounds = true
        
        button.backgroundColor = UIColor.customColor()
        
        button.addTarget(self, action: #selector(MURecordViewController.handlerButtonByClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -spacingVertical)
        
        self.view.addConstraint(verticalConstraint)
        
        //setting height to button
        let heightButtonConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: width)
        
        self.view.addConstraint(heightButtonConstraint)
        
        
        let hButtonConstraintVFL = "H:|-spacingHorizontal-[button(==120)]-spacingHorizontal-|"
        
        let hButtonConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hButtonConstraintVFL, options: NSLayoutFormatOptions.AlignAllCenterX, metrics: ["spacingHorizontal" : spacingHorizontal], views: ["button" : button])
        
        self.view.addConstraints(hButtonConstraint)
        
    
        
    }
    
    func handlerButtonByClicked(button : UIButton) {
        
        //Determine whether it is currently recording
        
        self.audioPlayer?.stop()
        
        if self.isRecording {
            
            //stop listening
            
            button.setTitle("Start", forState: UIControlState.Normal)
           
            do{
              
                try AVAudioSession.sharedInstance().setActive(false)
            }catch {
                
            }
           
            
            self.recorder?.stop()
            
            self.isRecording = false
            
            self.removeTimer()
            
        }else{
            
            button.setTitle("Stop", forState: UIControlState.Normal)
            
            self.isRecording = true
            
            self.startRecorder()
            
            self.addTimer()
            
        }
    }
    
    //recorder methods
    
    private func startRecorder() {
        
        //inital audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
          
           try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            
        }catch {
            
        }
        
        let audioSetting = [AVSampleRateKey :NSNumber(float: Float(44100.0)),AVFormatIDKey : NSNumber(int:Int32(kAudioFormatMPEG4AAC)),AVLinearPCMBitDepthKey : 8,AVNumberOfChannelsKey : NSNumber(int : 2),AVEncoderAudioQualityKey : NSNumber(int : Int32(AVAudioQuality.Medium.rawValue))]
        
        let url = self.directoryURL()
        
        do {
            
             self.recorder = try AVAudioRecorder(URL: url!, settings: audioSetting)
            
        }catch {
            
        }
       
        try! audioSession.setActive(true)
        
        self.recorder!.delegate = self
        
        self.recorder?.prepareToRecord()

        self.recorder?.record()

    }

   func directoryURL() -> NSURL? {
    
       //set the file name based on time
//       let currentDateTime = NSDate()
//    
//       let formatter = NSDateFormatter()
//    
//       formatter.dateFormat = "ddMMyyyyHHmmss"
//    
//       let recordingName = formatter.stringFromDate(currentDateTime)+".caf"
    
    let tempfile = "temp.caf"
    
    let fileManager = NSFileManager.defaultManager()
    
    let urls = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
    
    let documentDirectory = urls[0] as NSURL
    
    let soundURL = documentDirectory.URLByAppendingPathComponent(tempfile)
    
      return soundURL
    
    
   }
    //add a timer
    private func addTimer(){
        
        self.timer = NSTimer(timeInterval: 0.1, target: self, selector: #selector(MURecognitionViewController.changeShowTime), userInfo: nil, repeats: true)
        
        self.timer?.fire()
        
        self.timer?.fireDate = NSDate.distantPast()
    }
    
    //remove a timer
    private func removeTimer(){
        
        self.timer?.invalidate()
    }
    
    func changeShowTime() {
        
        let date = NSDate()
        
        let format = NSDateFormatter()
        
        format.dateFormat = "ss.SSS"
        
        let formatDate = format.stringFromDate(date)
        
        self.title = formatDate
        
    }
    
    //alert view
    private func alertView(text:String) {
        
        let alertViewController = UIAlertController(title: "Tips", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let tureAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.Default) { (action) in
            
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
            
            //self.usernameTextFiled?.resignFirstResponder()
            
            //self.passwordTextFiled?.resignFirstResponder()
            
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertViewController.addAction(tureAction)
        
        let dismissAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.Destructive) { (action) in
            
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
            
            // self.usernameTextFiled?.resignFirstResponder()
            
            // self.passwordTextFiled?.resignFirstResponder()
            
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertViewController.addAction(dismissAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }

    //MARK AVAudioRecorderDelegate.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recorder.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
