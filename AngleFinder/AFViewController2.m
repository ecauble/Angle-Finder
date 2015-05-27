//
//  AFViewController2.m
//  AngleFinder
//
//  Created by Eric Cauble on 3/7/14.
//  Copyright (c) 2014 Eric Cauble. All rights reserved.
//

#import "AFViewController2.h"
@interface AFViewController2 (){
    BOOL validate;
}

@end

@implementation AFViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    validate = false;
 	// Do any additional setup after loading the view.
    _targetAngleTextField.delegate = self;
    _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults synchronize];
    if([[[_defaults dictionaryRepresentation] allKeys] containsObject:@"angle"])
    {
        _targetAngleTextField.text = [_defaults stringForKey:@"angle"];
     }
    else{
        _targetAngleTextField.text = @"";
    }
    
    self.muteSwitch.on = ([[_defaults stringForKey:@"switchKey"]
                           
                           isEqualToString:@"On"]) ? (YES) : (NO);
    self.keepAwakeSwitch.on = ([[_defaults stringForKey:@"keepAwakeKey"]
                           
                           isEqualToString:@"On"]) ? (YES) : (NO);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)dismissKeyBoardOnTap:(id)sender {
    [self validateInput];
    if(validate == 0){
    }else{
        [self.view endEditing:YES];
    }
}

-(void)validateInput{
    if(self.targetAngleTextField.text.intValue < 0 || self.targetAngleTextField.text.intValue > 359){
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Out of range"
                                                         message:@"Angle must be within 0—359°"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [self.targetAngleTextField setText:@"0"];
        [self.view reloadInputViews];
        validate = NO;
        [alert show];
    }else{
        validate = YES;
         return;
    }
}

-(IBAction)muteSwitchWasTouched:(UISwitch *)sender{
    if (sender.on == 0) {
        [_defaults setObject:@"Off" forKey:@"switchKey"];
    } else if (sender.on == 1) {
        [_defaults setObject:@"On" forKey:@"switchKey"];
    }
    [_defaults synchronize];
}
 
-(IBAction)keepAwakeSwitchWasTouched:(UISwitch *)sender{
    if (sender.on == 0) {
        [_defaults setObject:@"Off" forKey:@"keepAwakeKey"];
    } else if (sender.on == 1) {
       UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Keep Awake Enabled"
                                                         message:@"Keeping the display awake can drastically reduce battery life if left idle for long periods of time."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: @"Cancel", nil];
        [_defaults setObject:@"On" forKey:@"keepAwakeKey"];
        [alert show];
    }
    [_defaults synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self validateInput];
    if ([segue.identifier isEqualToString:@"VC1Segue"]) {
        // Create strings and integer to store the text info
        NSInteger angle = [[_targetAngleTextField text] integerValue];
        // store the data
        [_defaults setInteger:angle forKey:@"angle"];
        [_defaults synchronize];
    }
    else return;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


@end
