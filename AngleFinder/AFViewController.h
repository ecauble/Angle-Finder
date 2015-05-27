//
//  AFViewController.h
//  AngleFinder
//
//  Created by Eric Cauble on 1/21/14.
//  Copyright (c) 2014 Eric Cauble. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFViewController : UIViewController
@property (nonatomic) NSInteger targetAngle;
@property (nonatomic) BOOL isMuted;
@property (weak,nonatomic) IBOutlet UILabel *angleLabel;
@property (weak,nonatomic) IBOutlet UIButton *detailsButton;
@property (weak,nonatomic)NSUserDefaults * defaults;
@end


