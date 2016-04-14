//
//  MURecorderViewController.m
//  Voice
//
//  Created by Adaman on 4/13/16.
//  Copyright © 2016 Adaman. All rights reserved.
//

#import "MURecorderViewController.h"

#import <AVFoundation/AVFoundation.h>

//#import "UIColor+MUCustomColor.h"

@interface MURecorderViewController ()<AVAudioRecorderDelegate>

//whether it is stsrting up
@property (nonatomic,assign)BOOL isRecording;


//whether "palybackButton" by clicked
@property (nonatomic,assign)BOOL isPlaying;


//define a timer
@property (nonatomic,strong)NSTimer *timer;


//define a audioPlayer object
@property (nonatomic,strong)AVAudioRecorder *recorder;

//define a recorder
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;


@end

@implementation MURecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Playback" style:UIBarButtonItemStylePlain target:self action:@selector(handlerRightBarItem:)];
    
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.isPlaying = NO;
    
    self.isRecording = NO;
    
    //setting delegate
    // self.iFlySpeechUnderstander!.delegate  = self
    
    [self customButton];
    

}
-(void)handlerRightBarItem:(UIBarButtonItem *)barItem {
    
    if (self.isPlaying) {
        
        [self.audioPlayer pause];
        
        self.isPlaying = NO;
    }else{
        
        if (self.recorder != nil) {
            
            NSError *error;
            
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.recorder.url error:&error];
           
            self.audioPlayer.volume = 1.0;
           
            
            [self.audioPlayer prepareToPlay];
            
            [self.audioPlayer play];
            
            self.isPlaying = YES;
            
        }else{
            
            [self alertView:@"You are not record audio"];
        }
    }

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
    
    [self.audioPlayer stop];
    
    if (self.isRecording) {
        
        //stop listening
        NSError *error;
        
        [sender setTitle:@"Start" forState:UIControlStateNormal];
       
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        
        [self.recorder stop];
        
        self.isRecording = NO;
        
        [self removeTimer];
        
    }else{
        
         [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        self.isRecording = YES;
        
        [self startRecorder];
        
        [self addTimer];
        
    }
    
}

//recorder methods

-(void)startRecorder{
    
    
    //inital audio session
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    
    NSError *error;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    //NSNumber(float: Float(44100.0))
    // NSNumber(int:Int32(kAudioFormatMPEG4AAC))
    NSDictionary * audioSetting = @{AVSampleRateKey : [NSNumber numberWithFloat:44100.0],AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVLinearPCMBitDepthKey : [NSNumber numberWithInt:8],AVNumberOfChannelsKey :[NSNumber numberWithInt:2],AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityMedium]};
    
    NSURL * url = [self directoryURL];
    
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:audioSetting error:&error];
    
    [audioSession setActive:YES error:&error];
    
    
    self.recorder.delegate = self;
    
    [self.recorder prepareToRecord];
    
    [self.recorder record];

}


-(NSURL *)directoryURL{
    
    //set the file name based on time
    //       let currentDateTime = NSDate()
    //
    //       let formatter = NSDateFormatter()
    //
    //       formatter.dateFormat = "ddMMyyyyHHmmss"
    //
    //       let recordingName = formatter.stringFromDate(currentDateTime)+".caf"
    
    NSString * tempfile = @"temp.caf";
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSArray * urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    
    NSURL * documentDirectory = urls[0];
    
    NSURL * soundURL = [documentDirectory URLByAppendingPathComponent:tempfile];
    
    return soundURL;
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
