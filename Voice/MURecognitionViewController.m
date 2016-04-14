//
//  MURecognitionViewController.m
//  Voice
//
//  Created by Adaman on 4/13/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

#import "MURecognitionViewController.h"

#import "iflyMSC/IFlySpeechUnderstander.h"

#import "iflyMSC/IFlySpeechUtility.h"

#import "iflyMSC/IFlyDataUploader.h"

//#import "UIColor+MUCustomColor.h"

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@interface MURecognitionViewController ()<IFlySpeechRecognizerDelegate>

//initlization recognition boject
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;

//whether it is listening
@property (nonatomic,assign)BOOL isStarting;


//whether "cancleButton" by clicked
@property (nonatomic,assign)BOOL isCancle;



//The end of the get rid of punctuation
@property (nonatomic,strong)NSString *tempString;


//recognition result
@property (nonatomic,strong)NSString *result;

//show time
@property (nonatomic,strong)UILabel *timeLabel;

//initalization a timer
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation MURecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStylePlain target:self action:@selector(handlerRightBarItem:)];
   
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //setting delegate
    // self.iFlySpeechUnderstander!.delegate  = self
    
    [self customButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handlerRightBarItem:(UIBarButtonItem *)barItem {
    
    self.isCancle = true;
    
    [self.iFlySpeechUnderstander cancel];
}

-(void)customButton{
    
    CGFloat width = 120.0;
    
    CGFloat spacingVertical = self.view.frame.size.height * 0.38;
    
    CGFloat spacingHorizontal = (self.view.frame.size.width - 120.0)/2.0;
    
    
    UIButton * button = [[UIButton alloc]init];
    
    button.translatesAutoresizingMaskIntoConstraints = false;
    
    [button setTitle:@"Start" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    //setting round button
    button.layer.cornerRadius = 60.0;
    
    button.layer.masksToBounds = true;
    
    button.backgroundColor = [UIColor customColor];
    
    [button addTarget:self action:@selector(handlerButtonByClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:button];
    
    NSLayoutConstraint * verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-spacingVertical];
   
    
    [self.view addConstraint:verticalConstraint];
    
    //setting height to button
    NSLayoutConstraint * heightButtonConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0 constant:width];
   
    
    [self.view addConstraint:heightButtonConstraint];
    
    
    NSString * hButtonConstraintVFL = @"H:|-spacingHorizontal-[button(==120)]-spacingHorizontal-|";
    
    NSDictionary *metrics = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",spacingHorizontal] forKey:@"spacingHorizontal"];
    
    NSArray * hButtonConstraint = [NSLayoutConstraint constraintsWithVisualFormat:hButtonConstraintVFL options:NSLayoutFormatAlignAllCenterX metrics:metrics views:@{@"button" : button}];
  
    
    [self.view addConstraints:hButtonConstraint];
}

-(void)handlerButtonByClicked:(UIButton *)sender {
    
    //Determine whether it is currently recording
    if (self.isStarting) {
        
        //stop listening
        [self.iFlySpeechUnderstander stopListening];
        
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        
        [self removeTimer];
        
        self.isStarting = NO;
    }else{
        
        //Monitor the recording
        
        //clear result in last time
        self.tempString = @"";
        
        self.iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
        
        self.iFlySpeechUnderstander.delegate = self;
        
        BOOL result = [self.iFlySpeechUnderstander startListening];
        
        if (result) {
            
            [sender setTitle:@"Stop" forState:UIControlStateNormal];

            self.isStarting = YES;
            
            [self addTimer];
            
            
        }else{
            
            NSString * const text = @"You need to run this feature on a real machine";
            
            [self alertView:text];
        }
        
    }

}

//add a timer
-(void) addTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(changeShowTime) userInfo:nil repeats:YES];
  
    
    [self.timer fire];
    
    self.timer.fireDate = [NSDate distantPast];
}

//remove a timer
-(void) removeTimer{
    
    [self.timer invalidate];
}

-(void)changeShowTime{
    
    NSDate * date = [NSDate date];
    
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    
    format.dateFormat = @"ss.SSS";
    
    NSString * formatDate = [format stringFromDate:date];
    
    self.title = formatDate;

}

//add a alert view for tips
-(void)alertView : (NSString *)text {
    
    UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"Tips" message:text preferredStyle:UIAlertControllerStyleAlert];

    
    
    UIAlertAction * tureAction = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertViewController addAction:tureAction];
    
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertViewController addAction:dismissAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

//#MARK IFlySpeechRecognizerDelegate
-(void)onCancel{
   
    //you don't need to achieve it,But you also can do somethings in here.

}
//monitor volume changed
-(void)onVolumeChanged:(int)volume{
    
    //you don't need to achieve it,But you also can do somethings in here.

}

-(void)onBeginOfSpeech{
    
    //you don't need to achieve it,But you also can do somethings in here.

}
-(void)onEndOfSpeech {
    
    //you don't need to achieve it,But you also can do somethings in here.

}

//handler error
-(void)onError:(IFlySpeechError *)errorCode{
    
    NSString * text = @"";
    
    if (self.isCancle) {
        
        text = @"You are clicking the cancle button.";
        
        [self alertView:text];
        
    }else if (errorCode == 0) {
        
        if (self.result.length == 0) {
            
            text = @"No recognition result.";
            
        }else{
            
            text = self.result;
        }
    }else{
        
        text = self.result;
    }
    
    [self alertView:text];

}

-(void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    
    
    //initlization a temp array
    NSArray * tempArray = [[NSArray alloc]init];
    
    
    
    NSMutableString * result = [[NSMutableString alloc]init];
    
    NSDictionary * dict_result_temp = [results lastObject];
    //  print("==============\(dict_result_temp)")
    //get the dictionary of allkeys
    for (NSString *key in dict_result_temp) {
        
        
        [result appendFormat:@"%@",key];
        
    }
    
    NSError *error;
    
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict_result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray * array_result = [dict_result objectForKey:@"ws"];
    
    for (int i = 0; i<array_result.count; i++) {
        
        tempArray = [[array_result objectAtIndex:i] objectForKey:@"cw"];
        
        NSDictionary * dict_cw = [tempArray objectAtIndex:0];
        
        NSString *tempNSString = [dict_cw objectForKey:@"w"];
        
        if ([tempNSString isEqualToString:@"."] || [tempNSString isEqualToString:@"?"] || [tempNSString isEqualToString:@"!"]) {
            
            
        } else {
            
           self.tempString = [self.tempString stringByAppendingString:[dict_cw objectForKey:@"w"]];
        }
    }
    
    self.result = _tempString;
    
    // self.alertView(self.result)
    


}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
