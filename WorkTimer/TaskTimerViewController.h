//
//  TaskTimerViewController.h
//  WorkTimer
//
//  Created by martin steel on 03/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"

@interface TaskTimerViewController : UIViewController

@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)startTouchUpInside:(id)sender;
- (IBAction)stopTouchUpInside:(id)sender;

@end
