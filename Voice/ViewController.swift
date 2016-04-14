//
//  ViewController.swift
//  Voice
//
//  Created by Adaman on 4/12/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //speech recognition
    var recognitiohButton = UIButton()
    
    //voice synthesics
    var synthesicsButton = UIButton()
    
    //record and playback
    var recordButton = UIButton()
    
    //width of button
    var widthButton:CGFloat = 0
    
    //height of button
    var heightButton:CGFloat = 0
    
    //Vertical spacing of button
    var vSpacingButton:CGFloat = 0
    
    //Horizontal Spacing of button
    var hSpacingButton:CGFloat = 0
    
    //spacing to top
    var spacingToTop:CGFloat = 0
    
    //defaluts in iPhone
    var cornerParameters:CGFloat = 0.175
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        //The resolve view Offset,you are also not setting it.
        self.edgesForExtendedLayout = UIRectEdge.None
        
        //setting some attributes to navigation controller
        self.title = "Welcome"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(18.0),NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation-background")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forBarMetrics: UIBarMetrics.Default)
        
        self.customButtons()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //initalization layout
    private func customButtons() {
        
        //initalizition,the unint is point.
        
        //MARK.
        //1inch = 2.54 centimeter = 72point = 144px
        
        self.widthButton = self.view.frame.width * 0.62
        
        self.hSpacingButton = (self.view.frame.width - self.widthButton)/2.0
        
        self.vSpacingButton = 24.0
        
        self.spacingToTop = self.view.frame.height * 0.38
        
        //defaluts in iPhone
        self.heightButton = 30.0
        
        if UIDevice.currentDevice().model == "iPad" {
            
            self.heightButton = 44.0
            
            self.cornerParameters = 0.225
        }
        
        //initlization button
        self.settingCustomButton(self.recognitiohButton,title: "Speech recognition",tag: 1001)
        
        self.settingCustomButton(self.synthesicsButton,title: "Voice synthesics",tag: 1002)
        
        self.settingCustomButton(self.recordButton,title: "Recording",tag: 1003)
        
        
        //initalization button with autolayout
        
        //Horizontal layout
        let hButtonConstraintVFL = "H:|-hSpacing-[recognitiohButton]-hSpacing-|"
        
        let hButtonConstraint = NSLayoutConstraint.constraintsWithVisualFormat(hButtonConstraintVFL, options: NSLayoutFormatOptions.AlignAllCenterX, metrics: ["hSpacing" : self.hSpacingButton], views: ["recognitiohButton" : self.recognitiohButton])
        
        self.view.addConstraints(hButtonConstraint)
        
        //setting height to button
        let heightButtonConstraint = NSLayoutConstraint(item: self.recognitiohButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: self.heightButton)
        
        self.view.addConstraint(heightButtonConstraint)

        
        //Vertical layout
        let vButtonConstraintVFL = "V:|-spacingToTop-[recognitiohButton]-vSpacingButton-[synthesicsButton(==recognitiohButton)]-vSpacingButton-[recordButton(==recognitiohButton)]"
        
        let vButtonConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vButtonConstraintVFL, options: NSLayoutFormatOptions.AlignAllLeft.union(NSLayoutFormatOptions.AlignAllRight), metrics: ["spacingToTop" : self.spacingToTop,"vSpacingButton" : self.vSpacingButton], views: ["recognitiohButton" : self.recognitiohButton,"synthesicsButton" : self.synthesicsButton,"recordButton" : self.recordButton])
        
        self.view.addConstraints(vButtonConstraint)
        
        
    }
    
    private func settingCustomButton(button : UIButton,title : String,tag : Int) {
    
    //if you forgot add this line code,autolayout will be invalid.
    button.translatesAutoresizingMaskIntoConstraints = false
        
    button.tag = tag
     //not work
    //button.titleLabel?.text = title
    button.setTitle(title, forState: UIControlState.Normal)
        
    button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    
    //setting title of button with font size
    button.titleLabel?.font = UIFont.systemFontOfSize(12.0)
    
    button.layer.cornerRadius = self.heightButton * self.cornerParameters
    
    button.backgroundColor = UIColor.clearColor()
    
    button.layer.borderColor = UIColor.customColor().CGColor
    
    button.layer.borderWidth = 2.0
        
    button.addTarget(self, action: #selector(ViewController.handlerButtonByClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    
    //it is very importance.it is not this line code,it will be not show never.
    self.view.addSubview(button)

    
    }
    
    func handlerButtonByClicked(button : UIButton) {
        
        if button.tag == 1001 {
            
            let controller = MURecognitionViewController()
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if button.tag == 1003 {
            
            let controller = MURecordViewController()
            
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            
            let controller = MUSynthesicsViewController()
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

//Extension UIColor for custom color
extension UIColor {
  
    //Declared as class methods
  class func customColor() -> UIColor {
        
        return UIColor(hue: 343, saturation: 94, brightness: 94, alpha: 1.0)
    }
}

