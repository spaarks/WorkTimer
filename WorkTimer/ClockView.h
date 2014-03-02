//
//  ClockViewController.h
//  WorkTimer
//
//  Created by martin steel on 15/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helpers.h"

@interface ClockView : UIView<NSCoding>

@property (weak, nonatomic) IBOutlet UILabel *timeString;
@property (nonatomic,strong) NSDate *currentTime;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property BOOL started;
@property BOOL isClockRunning;
@property (nonatomic,strong) NSDate *timeStarted;

- (void) start;
- (void) stop;
- (void) reset;

@end
