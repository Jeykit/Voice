//
//  ViewController.m
//  Voice
//
//  Created by Adaman on 4/22/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

#import "ViewController.h"

#import "iflyMSC/IFlySpeechUnderstander.h"

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@interface ViewController ()<IFlySpeechRecognizerDelegate>

//initalization a recognition object
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;

//Determine weather it is recording.
@property (nonatomic,assign) BOOL isRecording;

//recognition result
@property (nonatomic,strong) NSString * result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //setting background color for view
    self.view.backgroundColor = [UIColor whiteColor];
    
    //setting title for current controller
    self.title = @"Voice Recognition";
    
    //defalut it is not recording.
    self.isRecording = NO;
    
    //defalut it is nil.
    self.result = @"";
    
    //initalization a recognition instance
    self.iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlerButtonByClicked:(UIButton *)sender {
    
    if (self.isRecording) {
        
        //if it is recording ,stop recording
        [self.iFlySpeechUnderstander stopListening];
        
        //setting button title to "Start".
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        
        //toggle ststus
        self.isRecording = NO;
        
    }else{
        
        //start recording
        BOOL flag = [self.iFlySpeechUnderstander startListening];
        
        //setting delegate
        self.iFlySpeechUnderstander.delegate = self;
        
        if (flag) {
            
            //toggle status
            self.isRecording = YES;
            
            //setting title to "Stop"
            [sender setTitle:@"Stop" forState:UIControlStateNormal];
            
            self.result = @"";
            
        }else{
            
            NSString *text = @"Can not be indentified";
            
            [self alertView:text :YES];
        }
        
    }
}
//#MARK IFlySpeechRecognizerDelegate
-(void)onCancel{
    
    //you don't need to achieve it,But can do somethings in here.
}
-(void)onVolumeChanged:(int)volume{
    
    //you don't need to achieve it,But can do somethings in here.
}
-(void)onBeginOfSpeech{
    
    //you don't need to achieve it,But can do somethings in here.
}
-(void)onEndOfSpeech{
    
    //you don't need to achieve it,But can do somethings in here.
}
-(void)onError:(IFlySpeechError *)errorCode{
    NSString *text = @"";
    
    //Recognition success
    if (errorCode == 0) {
        
        //the length of results is zero.
        if (self.result.length == 0) {
            
            text = @"No recognition results.";
            
        }else{
            
            text = self.result;
        }
    }else{
        
        text = self.result;
    }
    
    [self alertView:text :YES];
   
}
-(void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    
    
    //initlization a temp array
    NSArray * tempArray = [[NSArray alloc]init];

    //initalization a temp string
    NSMutableString * reveivedString = [[NSMutableString alloc]init];
    
    //get the last result
    NSDictionary * dict_result_temp = [results lastObject];
    //get the dictionary of allkeys
    
    NSLog(@"%@",dict_result_temp);
    
    for (NSString *key in dict_result_temp) {
        
        //The resulting string splicing
        [reveivedString appendFormat:@"%@",key];
        
    }
    
    NSError *error;
    
    //Formatted data
    NSData * data = [reveivedString dataUsingEncoding:NSUTF8StringEncoding];
    
    //Parsing Json data
    NSDictionary * dict_result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray * array_result = [dict_result objectForKey:@"ws"];
    
    for (int i = 0; i<array_result.count; i++) {
        
        tempArray = [[array_result objectAtIndex:i] objectForKey:@"cw"];
        
        NSDictionary * dict_cw = [tempArray objectAtIndex:0];
        
        NSString *tempNSString = [dict_cw objectForKey:@"w"];
        
        if ([tempNSString isEqualToString:@"."] || [tempNSString isEqualToString:@"?"] || [tempNSString isEqualToString:@"!"]) {
            
            
        } else {
            
            self.result = [self.result stringByAppendingString:[dict_cw objectForKey:@"w"]];
        }
    }
    
    
    // self.alertView(self.result)

}
//create a alert view for showing resluts
-(void)alertView : (NSString *) text : (BOOL) flag{
    
    //initalization a alertViewController
    UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"Recognition Results" message:text preferredStyle:UIAlertControllerStyleAlert];
    
    //add action to alertViewController
    UIAlertAction *action_Sure = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //let alertViewControler dismiss
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //add action to alertViewController
    [alertViewController addAction:action_Sure];
    
    UIAlertAction *action_Cancle = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //let alertViewController dismiss
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertViewController addAction:action_Cancle];
    
//    if (flag) {
//        //show results to viewController
//        [self presentViewController:alertViewController animated:YES completion:nil];
//    }
    
    //show results to user
    [self presentViewController:alertViewController animated:YES completion:nil];
}
@end
