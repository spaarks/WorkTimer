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

@interface TaskTimerViewController : UIViewController <ProtocolIPhoneEditWorkLogButtonClicked, NSCoding>

@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (strong, nonatomic) WorkTimerTask *currentWorkTimerTask;

@property (weak, nonatomic) IBOutlet UITextView *taskSummaryTextView;
@property (weak, nonatomic) IBOutlet UILabel *taskCodeLabel;


- (IBAction)startTouchUpInside:(id)sender;
- (IBAction)stopTouchUpInside:(id)sender;


@end
