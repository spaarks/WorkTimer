//
//  TaskTimerViewController.m
//  WorkTimer
//
//  Created by martin steel on 03/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "TaskTimerViewController.h"

@implementation TaskTimerViewController

@synthesize currentWorkTimerTask = _currentWorkTimerTask;

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
        [self.stopButton setEnabled:NO];
        [self.clockView stop];
        
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    //We're back from lunch so start the timer again
    else
    {
        [self.stopButton setEnabled:YES];
        
        [self.clockView start];
        
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)stopTouchUpInside:(id)sender
{
    [self.clockView stop];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [self performSegueWithIdentifier:@"OpenStopSegue" sender:self];
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OpenStopSegue"])
    {
        IPhoneEditWorkLogViewController *editView = [segue destinationViewController];
        
        WorkTimerTask *taskToEdit;
        taskToEdit = self.getRunningWorkTimerTask;
        
        //[self getRunningWorkTimerTask];
        
        [editView setCurrentWorkTimerTask:taskToEdit];
    }
}

- (WorkTimerTask *)getRunningWorkTimerTask
{
    WorkTimerTask *taskToEdit = [[WorkTimerTask alloc] init];
    
    NSDate *currentTime = self.clockView.currentTime;
    NSString *currentTimeString = [Helpers getJIRATimeString:currentTime];
    
    taskToEdit.timeWorked = currentTimeString;
    taskToEdit.timeWorkedTime = currentTime;
    taskToEdit.taskDescription = _currentWorkTimerTask.taskDescription;
    taskToEdit.taskID = _currentWorkTimerTask.taskID;
    taskToEdit.taskKey = _currentWorkTimerTask.taskKey;
    taskToEdit.taskSummary = _currentWorkTimerTask.taskSummary;
    
    
    return taskToEdit;
}
@end
