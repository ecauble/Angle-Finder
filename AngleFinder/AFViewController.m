//
//  AFViewController.m
//  AngleFinder
//
//  Created by Eric Cauble on 1/21/14.
//  Copyright (c) 2014 Eric Cauble. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "AFViewController.h"
#define kAccelerometerPollingInterval	(1.0/6.0) //update 10 times/sec


@interface AFViewController ()
{
	CMMotionManager	*motionManager;
    AVAudioPlayer * beep;
    NSString * mySwitchVal;
    NSString * keepAwakeVal;
}

- (void)updateAccelerometerTime:(NSTimer*)timer;

@end

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

     _defaults = [NSUserDefaults standardUserDefaults];
    [self readDefaults];
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"]];
     beep = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    [beep setVolume:1.0];
    
    //set view color
    [self changeColorsWithState: 0];
    
    motionManager = [CMMotionManager new];
	motionManager.accelerometerUpdateInterval = kAccelerometerPollingInterval;
    //update motionManager
	[motionManager startAccelerometerUpdates];
    // Start a timer to periodically poll the accelerometer
	[NSTimer scheduledTimerWithTimeInterval:kAccelerometerPollingInterval target:self selector:@selector(updateAccelerometerTime:) userInfo:nil repeats:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

#pragma mark onLoad
-(void) readDefaults{
    
    [_defaults synchronize];
    
    //set mute value for sound
    if([[[_defaults dictionaryRepresentation] allKeys] containsObject:@"switchKey"])
    {
        mySwitchVal = [_defaults stringForKey:@"switchKey"];
    }
    else{
        [_defaults setObject:@"Off" forKey:@"switchKey"];
    }
    
    //set target angle from defaults
    if([[[_defaults dictionaryRepresentation] allKeys] containsObject:@"angle"])
    {
        _targetAngle = [_defaults integerForKey:@"angle"];
    }
    else{
        _targetAngle = 0;
    }
   
    //keep the screen awake
    if([[[_defaults dictionaryRepresentation] allKeys] containsObject:@"keepAwakeKey"])
    {
        keepAwakeVal = [_defaults stringForKey:@"keepAwakeKey"];
        if([keepAwakeVal isEqualToString: @"On"])
        {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        }
    }
    else
    {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        NSLog(@"keep awake off!");

    }
}

#pragma mark Periodic
- (void)updateAccelerometerTime:(NSTimer *)timer
{
    CMAcceleration acceleration = motionManager.accelerometerData.acceleration;
	double rotation = atan2(acceleration.y,-acceleration.z);
    //convert the angle to degrees and update the angleLabel
    [self updateAngleLabel:rotation];
}

#pragma mark GeneralClassMethods
 - (void)updateAngleLabel:(double)rotation
{
    
        // Convert radians to degrees
        NSInteger degrees = round(-rotation*180.0/M_PI);
        //fix range between 0 and 360
        if (degrees<0)
            degrees+=360;
        _angleLabel.text = [NSString stringWithFormat:@"%u\u00b0",(unsigned)degrees];
        //if +- 1 degree to target
        if(degrees >= (_targetAngle - 1) && degrees <= (_targetAngle + 1) && degrees!= _targetAngle)
        {
            [self changeColorsWithState: 1];
         }
        //if hit target angle
        else if(degrees == _targetAngle)
        {
            if([mySwitchVal isEqualToString: @"Off"]){
                [beep play];
            }
            [self changeColorsWithState: 2];
        }
        else
        {
            //default state
            [self changeColorsWithState: 0];
        }
}



//changes background and text colors
-(void) changeColorsWithState: (int) state {
    
    switch (state) {
        case 0://set background black, text white
            self.view.backgroundColor = [UIColor blackColor];
            _angleLabel.backgroundColor = [UIColor blackColor];
            _angleLabel.textColor = [UIColor whiteColor];
            [self.detailsButton setImage:[UIImage imageNamed:@"gear_ww.png"] forState:UIControlStateNormal];
            _detailsButton.backgroundColor  = [UIColor blackColor];
             break;
        
        case 1://light gray background, white text?
            self.view.backgroundColor = [UIColor lightGrayColor];
            _angleLabel.backgroundColor = [UIColor lightGrayColor];
            _angleLabel.textColor = [UIColor darkGrayColor];
            [self.detailsButton setImage:[UIImage imageNamed:@"gear_g.png"] forState:UIControlStateNormal];
            _detailsButton.backgroundColor  = [UIColor lightGrayColor];
             break;
            
        case 2:
            self.view.backgroundColor = [UIColor whiteColor];
            _angleLabel.backgroundColor = [UIColor whiteColor];
            _angleLabel.textColor = [UIColor blackColor];
            [self.detailsButton setImage:[UIImage imageNamed:@"gear_b.png"] forState:UIControlStateNormal];
            _detailsButton.backgroundColor  = [UIColor whiteColor];
             break;
            
        default:
            break;
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{

        return UIStatusBarStyleLightContent;
}

-(IBAction)switchToView2:(id)sender{
    [beep stop];
    [motionManager stopAccelerometerUpdates];
    beep = nil;
    motionManager = nil;
    [_defaults synchronize];
    return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
