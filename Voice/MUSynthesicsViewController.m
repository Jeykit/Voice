//
//  MUSynthesicsViewController.m
//  Voice
//
//  Created by Adaman on 4/13/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

#import "MUSynthesicsViewController.h"

#import "iflyMSC/IFlySpeechSynthesizer.h"

#import <AVFoundation/AVAudioSession.h>

#import <AudioToolbox/AudioSession.h>

#import <AVFoundation/AVFoundation.h>

//#import "UIColor+MUCustomColor.h"

#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

#import "iflyMSC/IFlySpeechConstant.h"

@interface MUSynthesicsViewController ()<IFlySpeechSynthesizerDelegate>

//text input
@property (nonatomic,strong) UITextView *textView;

//defined a voice synthesics object
@property (nonatomic,strong)IFlySpeechSynthesizer *synthesis;

//voice storage path
@property (nonatomic,copy)NSString *filePath;

//define a audioPlayer object
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;

@end

@implementation MUSynthesicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Synthesics" style:UIBarButtonItemStylePlain target:self action:@selector(handlerRightBarItem:)];
    
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //setting delegate
    // self.iFlySpeechUnderstander!.delegate  = self
    
    self.textView = [[UITextView alloc]initWithFrame:self.view.frame];
    
    [self.textView becomeFirstResponder];
   
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineSpacing = 30.0;
    
    paragraphStyle.maximumLineHeight = 60.0;
    
    paragraphStyle.firstLineHeadIndent = 12.0;
    
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary * attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:12.0],NSParagraphStyleAttributeName : paragraphStyle};
    
    self.textView.attributedText =[[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attribute];
    
    //UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationItem])
    
    [self.view addSubview:self.textView];
    
    self.synthesis = [IFlySpeechSynthesizer sharedInstance];
    
    self.synthesis.delegate = self;
    


}

-(void)handlerRightBarItem:(UIBarButtonItem *)barItem {
    
    
    if (self.textView.text.length > 0)  {
        
        [self startSynthesies];
        
    }else{
        
        NSString * const alertText = @"Sorry,The text can not be empty!";
        
        [self alertView:alertText];
    }
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

-(void)startSynthesies{
  
    //setting speed 1-100
    [self.synthesis setParameter:@"50" forKey: [IFlySpeechConstant SPEED]];
    
    //setting volume 1-100
    [self.synthesis setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    
    //setting pitch1-100
    [self.synthesis setParameter:@"50" forKey: [IFlySpeechConstant PITCH]];
    
    //setting sample_rate
     [self.synthesis setParameter:@"16000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    
    //setting voice_name
    //self.synthesis?.setParameter("Catherine", forKey: IFlySpeechConstant.VOICE_NAME())
     [self.synthesis setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
    
    NSString * fPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
   
    
    //let prePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    
    self.filePath = [fPath stringByAppendingPathComponent:@"tts.pcm"];
   
    [self.synthesis setParameter:@"tts.pcm" forKey:self.filePath];

    [self.synthesis startSpeaking:self.textView.text];
   
    
    

}

//MARK IFlySpeechSynthesizerDelegate
-(void)onSpeakBegin{
    
}

-(void)onBufferProgress:(int)progress message:(NSString *)msg{
    
}

-(void)onSpeakProgress:(int)progress {
    
}

-(void)onCompleted:(IFlySpeechError *)error{
    
    NSError * reError;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&reError];
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:self.filePath] error:&reError];
    
    [self.audioPlayer prepareToPlay];
    
    [self.audioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
