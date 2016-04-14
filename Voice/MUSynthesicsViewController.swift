//
//  MUSynthesicsViewController.swift
//  Voice
//
//  Created by Adaman on 4/13/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

import UIKit

class MUSynthesicsViewController: UIViewController,IFlySpeechSynthesizerDelegate {

    //text input
    private var textView:UITextView?
    
    //defined a voice synthesics object
    private var synthesis : IFlySpeechSynthesizer?
    
    //voice storage path
    private var path:String?
    
    //define a audioPlayer object
    private var audioPlayer:AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Synthesis"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(18.0),NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let rightBarItem = UIBarButtonItem(title: "Synthesics", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MUSynthesicsViewController.handlerRightBarItem(_:)))
        
        self.navigationItem.rightBarButtonItem = rightBarItem

        
        self.textView = UITextView()
        
        self.textView?.becomeFirstResponder()
        
        self.textView?.frame = self.view.frame
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 30.0
        
        paragraphStyle.maximumLineHeight = 60.0
        
        paragraphStyle.firstLineHeadIndent = 12.0
        
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let attribute = [NSFontAttributeName : UIFont.systemFontOfSize(12.0),NSParagraphStyleAttributeName : paragraphStyle]
        
        self.textView?.attributedText = NSMutableAttributedString(string: self.textView!.text, attributes: attribute)
        
        //UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationItem])
        
        self.view.addSubview(self.textView!)
        
        self.synthesis = IFlySpeechSynthesizer.sharedInstance()
        
        self.synthesis!.delegate = self


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlerRightBarItem(barItem : UIBarButtonItem) {
        
        let voiceText = (self.textView?.text)! as NSString
        
        if voiceText.length > 0  {
            
            self.startSynthesies()
        }else{
            
            let alertText = "Sorry,The text can not be empty!"
            
            self.alertView(alertText)
        }

    }

    func startSynthesies() {
        
        //setting speed 1-100
        self.synthesis?.setParameter("50", forKey: IFlySpeechConstant.SPEED())
        
        //setting volume 1-100
        self.synthesis?.setParameter("50", forKey: IFlySpeechConstant.VOLUME())
        
        //setting pitch1-100
        self.synthesis?.setParameter("50", forKey:IFlySpeechConstant.PITCH())
        
        //setting sample_rate
        self.synthesis?.setParameter("16000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        
        //setting voice_name
        //self.synthesis?.setParameter("Catherine", forKey: IFlySpeechConstant.VOICE_NAME())
        
        self.synthesis?.setParameter("xiaoyan", forKey: IFlySpeechConstant.VOICE_NAME())
        
        let filePath:NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        
        //let prePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        
        self.path = filePath.stringByAppendingPathComponent("tts.pcm")
        
        self.synthesis?.setParameter("tts.pcm", forKey: self.path)
        
        self.synthesis?.startSpeaking(self.textView?.text)
        
        
    }
    
    //MARK IFlySpeechSynthesizerDelegate
    func onSpeakBegin() {
        
        //print("=========================good!")
    }
    
    func onBufferProgress(progress: Int32, message msg: String!) {
        
        //print("=========================\(progress)=====\(msg)")
    }
    
    func onSpeakProgress(progress: Int32) {
        
        //print("=========================\(progress)=====")
    }
    
    func onCompleted(error: IFlySpeechError!) {
        
        do{
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
        }catch let error as NSError {
            
            print("===================\(error)")
        }
        
        do {
            
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: self.path!))
        }catch {
            
        }
        
        
        self.audioPlayer?.prepareToPlay()
        
        
    }
    
    private func alertView(text:String) {
        
        let alertViewController = UIAlertController(title: "Tips", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let tureAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.Default) { (action) in
            
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertViewController.addAction(tureAction)
        
        let dismissAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.Destructive) { (action) in
            
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertViewController.addAction(dismissAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
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
