//
//  TaskTimerViewController.m
//  WorkTimer
//
//  Created by martin steel on 03/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "TaskTimerViewController.h"

@implementation TaskTimerViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTouchUpInside:(id)sender
{
    //We've started the timer so pause to go for lunch
    if(self.clockView.isClockRunning)
    {
        [self.clockView.activityIndicator setHidden:false];
        
        [self.stopButton setEnabled:NO];
        [self.clockView stop];
        
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    //We're back from lunch so start the timer again
    else
    {
        [self.clockView.activityIndicator setHidden:false];
        [self.stopButton setEnabled:YES];
        
        [self.clockView start];
        
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)stopTouchUpInside:(id)sender {
}
@end
