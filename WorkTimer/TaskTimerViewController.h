//
//  TaskTimerViewController.h
//  WorkTimer
//
//  Created by martin steel on 03/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"
#import "WorkTimerTask.h"
#import "IPhoneEditWorkLogViewController.h"
#import "ProtocolIPhoneEditWorkLogButtonClicked.h"
#import "FUIButton.h"
#import "styling.h"

@interface TaskTimerViewController : UIViewController <ProtocolIPhoneEditWorkLogButtonClicked, NSCoding>

@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property (weak, nonatomic) IBOutlet UIView *clockViewBackground;
@property (weak, nonatomic) IBOutlet FUIButton *startButton;
@property (weak, nonatomic) IBOutlet FUIButton *stopButton;

@property (strong, nonatomic) WorkTimerTask *currentWorkTimerTask;

@property (weak, nonatomic) IBOutlet UILabel *taskCodeHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskSummaryHeaderLabel;

@property (weak, nonatomic) IBOutlet UITextView *taskSummaryTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskCodeLabel;


- (IBAction)startTouchUpInside:(id)sender;
- (IBAction)stopTouchUpInside:(id)sender;


@end
