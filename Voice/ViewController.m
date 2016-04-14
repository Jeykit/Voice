//
//  ViewController.m
//  Voice
//
//  Created by Adaman on 4/13/16.
//  Copyright © 2016 Adaman. All rights reserved.
//


#import "ViewController.h"

//#import "UIColor+MUCustomColor.h"

#import <Foundation/Foundation.h>

#import "MURecognitionViewController.h"

#import "MUSynthesicsViewController.h"

#import "MURecorderViewController.h"

@interface ViewController ()
    
    //speech recognition
    @property (nonatomic,strong)UIButton * recognitionButton;
    
    //voice synthesics
    @property (nonatomic,strong)UIButton * synthesicsButton;

    //record and playback
    @property (nonatomic,strong) UIButton * recordButton;

    //width of button
    @property (nonatomic,assign) CGFloat widthButton;

    //height of button
    @property (nonatomic,assign) CGFloat heightButton;
    
    //Vertical spacing of button
    @property (nonatomic,assign) CGFloat vSpacingButton;
    
    //Horizontal Spacing of button
    @property (nonatomic,assign) CGFloat hSpacingButton;
    
    //spacing to top
    @property (nonatomic,assign) CGFloat spacingToTop;
    
    //defaluts in iPhone
    @property (nonatomic,assign) CGFloat cornerParameters;
    


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //setting background coor
    self.view.backgroundColor = [UIColor whiteColor];
    
    //The resolve view Offset,you are also not setting it.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //setting some attributes to navigation controller
    self.title = @"Welcome";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-background"] forBarMetrics:UIBarMetricsDefault];
    
    [self customButtons];

}

-(void)customButtons {
    
    //initalizition,the unint is point.
    
    //MARK.
    //1inch = 2.54 centimeter = 72point = 144px
    
    self.widthButton = self.view.frame.size.width * 0.62;
    
    self.hSpacingButton = (self.view.frame.size.width - self.widthButton)/2.0;
    
    self.vSpacingButton = 24.0;
    
    //defalut in iPhone
    self.cornerParameters = 0.175;
    
    self.spacingToTop = self.view.frame.size.height * 0.38;
    
    //defaluts in iPhone
    self.heightButton = 30.0;
    
    
    if ([[UIDevice currentDevice].model  isEqual: @"iPad"]) {
        
        self.heightButton = 44.0;
        
        self.cornerParameters = 0.225;
    }
    
    //initlization button
    self.recognitionButton = [[UIButton alloc]init];
    
    [self settingCustomButton:self.recognitionButton titleForButton:@"Speech recognition" tag:1001];
    
    self.synthesicsButton = [[UIButton alloc]init];
    
    [self settingCustomButton:self.synthesicsButton titleForButton:@"Voice synthesics" tag:1002];
    
    self.recordButton = [[UIButton alloc] init];
    
    [self settingCustomButton:self.recordButton titleForButton:@"Recording" tag:1003];
    
    
    //initalization button with autolayout
    
    NSString * hSpacing = [NSString stringWithFormat:@"%f",self.hSpacingButton];
    
    NSDictionary *metrics = [NSDictionary dictionaryWithObject:hSpacing forKey:@"hSpacing"];
    
    NSDictionary *views = [NSDictionary dictionaryWithObject:self.recognitionButton forKey:@"recognitiohButton"];
    //Horizontal layout
   NSString * hButtonConstraintVFL = @"H:|-hSpacing-[recognitiohButton]-hSpacing-|";
    
    NSArray * hButtonConstraint = [NSLayoutConstraint constraintsWithVisualFormat:hButtonConstraintVFL options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views];
    
    [self.view addConstraints:hButtonConstraint];
    
    //setting height to button
    NSLayoutConstraint * heightButtonConstraint = [NSLayoutConstraint constraintWithItem:self.recognitionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0 constant:self.heightButton];

    
    [self.view addConstraint:heightButtonConstraint];
    
    
    //Vertical layout
    NSString * vButtonConstraintVFL = @"V:|-spacingToTop-[recognitiohButton]-vSpacingButton-[synthesicsButton(==recognitiohButton)]-vSpacingButton-[recordButton(==recognitiohButton)]";
    
    NSDictionary *vMetrics = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",self.spacingToTop],@"spacingToTop",[NSString stringWithFormat:@"%f",self.vSpacingButton],@"vSpacingButton", nil];
    
    NSArray * vButtonConstraint = [NSLayoutConstraint constraintsWithVisualFormat:vButtonConstraintVFL options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:vMetrics views:@{@"recognitiohButton" : self.recognitionButton,@"synthesicsButton" : self.synthesicsButton,@"recordButton" : self.recordButton}];
    
    
    [self.view addConstraints:vButtonConstraint];
    

}

-(void)settingCustomButton:(UIButton *)button titleForButton : (NSString *)title tag:(int)tag{
    
    //if you forgot add this line code,autolayout will be invalid.
    button.translatesAutoresizingMaskIntoConstraints = false;
    
    button.tag = tag;
    //not work
    //button.titleLabel?.text = title
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTintColor:[UIColor blackColor]];
    
    //setting title of button with font size
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];

    button.layer.cornerRadius = self.heightButton * self.cornerParameters;
    
    button.backgroundColor = [UIColor customColor];
    
    button.layer.borderColor = [UIColor customColor].CGColor;
    
    button.layer.borderWidth = 2.0;
    
    [button addTarget:self action:@selector(handlerButtonByClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //it is very importance.it is not this line code,it will be not show never.
    [self.view addSubview:button];

}

-(void)handlerButtonByClicked:(UIButton *)sender {
    
    if (sender.tag == 1001) {
        
        MURecognitionViewController * controller = [[MURecognitionViewController alloc]init];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (sender.tag == 1002) {
        
        MUSynthesicsViewController * controller = [[MUSynthesicsViewController alloc]init];
        
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        
        MURecorderViewController * controller = [[MURecorderViewController alloc]init];
        
        [self.navigationController pushViewController:controller animated:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
