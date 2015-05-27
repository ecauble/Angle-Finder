//
//  AFViewController2.h
//  AngleFinder
//
//  Created by Eric Cauble on 3/7/14.
//  Copyright (c) 2014 Eric Cauble. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFViewController2 : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *targetAngleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *keepAwakeSwitch;
@property (weak, nonatomic) NSUserDefaults * defaults;
- (IBAction)dismissKeyBoardOnTap:(id)sender;

@end
