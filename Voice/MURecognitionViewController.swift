//
//  MURecognitionViewController.swift
//  Voice
//
//  Created by Adaman on 4/12/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

import UIKit


class MURecognitionViewController: UIViewController,IFlySpeechRecognizerDelegate {

    //initlization recognition boject
    private var iFlySpeechUnderstander:IFlySpeechUnderstander?
    
    //whether it is listening
    private var isStarting:Bool = false
    
    //whether "cancleButton" by clicked
    private var isCancle:Bool = false
    
    
    //The end of the get rid of punctuation
    private var tempString:String = ""
    
    //recognition result
    private var result:String = ""
    
    //show time
    private let timeLabel = UILabel()
    
    //initalization a timer
    private var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let rightBarItem = UIBarButtonItem(title: "Cancle", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MURecognitionViewController.handlerRightBarItem(_:)))
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        //setting delegate
       // self.iFlySpeechUnderstander!.delegate  = self
        
        self.customButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlerRightBarItem(barItem : UIBarButtonItem) {
        
        self.isCancle = true
        
        self.iFlySpeechUnderstander!.cancel()
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
        
        button.addTarget(self, action: #selector(MURecognitionViewController.handlerButtonByClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        if self.isStarting {
            
            //stop listening
            self.iFlySpeechUnderstander!.stopListening()
            
            button.setTitle("Start", forState: UIControlState.Normal)
            
            self.removeTimer()
            
            self.isStarting = false
        }else{
            
            //Monitor the recording
            
            //clear result in last time
            self.tempString = ""
            
            self.iFlySpeechUnderstander = IFlySpeechUnderstander.sharedInstance()
            
            self.iFlySpeechUnderstander?.delegate = self
            
           let result = self.iFlySpeechUnderstander!.startListening()
            
            if result {
                
                button.setTitle("Stop", forState: UIControlState.Normal)
                
                self.isStarting = true
                
                self.addTimer()
                
               
            }else{
                
                let text = "You need to run this feature on a real machine"
                
                self.alertView(text)
            }
            
        }
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
    
    //add alert view for tips
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
    
    //#MARK IFlySpeechRecognizerDelegate
    func onCancel() {
        
        //you don't need to achieve it,But you also can do somethings in here.
    }
    
    //monitor volume changed
    func onVolumeChanged(volume: Int32) {
        
      //you don't need to achieve it,But you also can do somethings in here.
        
    }

    
    func onBeginOfSpeech() {
        
       //you don't need to achieve it,But you also can do somethings in here.
        
    }
    
    func onEndOfSpeech() {
        
        //you don't need to achieve it,But you also can do somethings in here.
    }
    
    //handler error
    func onError(errorCode: IFlySpeechError!) {
        
         var text = ""
        
        if self.isCancle {
            
           text = "You are clicking the cancle button."
            
            self.alertView(text)
            
        }else if errorCode == 0 {
            
            if (self.result as NSString).length == 0 {
                
               text = "No recognition result."
                
            }else{
                
                text = self.result
            }
        }else{
            
            text = self.result
        }
        
        self.alertView(text)
        
    }
    
    func onResults(results: [AnyObject]!, isLast: Bool) {
        
        //initlization a temp array
        var tempArray = NSArray()
        
       
        
        let result = NSMutableString()
        
        let dict_result_temp = results.last as? NSDictionary
        
       //  print("==============\(dict_result_temp)")
        //get the dictionary of allkeys
        for element in dict_result_temp!.allKeys {
            
            let tString = element as! String
            
            result.appendFormat("%@", tString)
            
        }
        
       
        
         print("==============\(result)")
        
        let data = result.dataUsingEncoding(NSUTF8StringEncoding)
        
        do {
          
             let dict_result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
            
            let array_result = dict_result.objectForKey("ws") as! NSArray
            
            for index in 0 ..< array_result.count {
                
                tempArray = array_result.objectAtIndex(index).objectForKey("cw") as! NSArray
                
                let dict_cw = tempArray.objectAtIndex(0) as! NSDictionary
                
                let tempNSString = dict_cw.objectForKey("w") as! NSString
                
                // tempString =  tempString.stringByAppendingString(dict_cw.objectForKey("w") as! String)
                
               // The end of the get rid of punctuation
                if tempNSString.isEqualToString(".") || tempNSString.isEqualToString("?") || tempNSString.isEqualToString("!"){
                    
                }else{
                    
                     tempString =  tempString.stringByAppendingString(dict_cw.objectForKey("w") as! String)
                }
               
                 //print("=============\(tempString)")
            }
            
            
        }catch {
            
            //
        }
        
        print("=============\(tempString)")
        
        self.result = tempString
        
       // self.alertView(self.result)
        
        
        
     
     
        
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
