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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.taskCodeLabel.text = _currentWorkTimerTask.taskKey;
    self.taskSummaryTextView.text = _currentWorkTimerTask.taskSummary;
    
    [styling setPrimaryButtonStyling:self.startButton];
    [styling setPrimaryButtonStyling:self.stopButton];
    
    UIFont* clockFont = [styling getFont:@"FontLight":60];
    self.clockView.timeString.font = clockFont;
    
    [styling setHeaderLabelStyling:self.taskCodeHeaderLabel];
    [styling setHeaderLabelStyling:self.taskSummaryHeaderLabel];
    
    [styling setContentLabelStyling:self.taskCodeLabel];
    [styling setContentTextViewStyling:self.taskSummaryTextView];
    
    [styling setSecondaryBackground:self.clockViewBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTouchUpInside:(id)sender
{
    if(self.clockView.isClockRunning)
        [self pauseClock];

    else
        [self resumeClock];
}

//We've started the timer so pause to go for lunch
- (void)pauseClock
{
    [self.clockView stop];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [styling setPrimaryButtonStyling:self.startButton];
}

//We're back from lunch so start the timer again
- (void)resumeClock
{
    [self.clockView start];
    [self.startButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    [styling setSecondaryButtonStyling:self.startButton];
}

- (IBAction)stopTouchUpInside:(id)sender
{
    [self.clockView stop];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    
    [self performSegueWithIdentifier:@"OpenStopSegue" sender:self];
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OpenStopSegue"])
    {
        IPhoneEditWorkLogViewController *editView = [segue destinationViewController];
     
        editView.delegate = (id<ProtocolIPhoneEditWorkLogButtonClicked>)self;
        
        WorkTimerTask *taskToEdit;
        taskToEdit = self.getRunningWorkTimerTask;
        [editView setCurrentWorkTimerTask:taskToEdit];
    }
}

- (WorkTimerTask *)getRunningWorkTimerTask
{
    WorkTimerTask *taskToEdit = [[WorkTimerTask alloc] init];
    
    NSDate *currentTime = self.clockView.currentTime;

    currentTime = [Helpers roundDate:currentTime];
    
    NSString *currentTimeString = [Helpers getJIRATimeString:currentTime];
    
    taskToEdit.timeWorked = currentTimeString;
    taskToEdit.timeWorkedTime = currentTime;
    taskToEdit.taskDescription = _currentWorkTimerTask.taskDescription;
    taskToEdit.taskID = _currentWorkTimerTask.taskID;
    taskToEdit.taskKey = _currentWorkTimerTask.taskKey;
    taskToEdit.taskSummary = _currentWorkTimerTask.taskSummary;
    
    return taskToEdit;
}

#pragma ProtocolIPhoneEditWorkLogButtonClicked


-(void)commitClicked:(WorkTimerTask*)task
{
    FakeProjectRepository *repo = [[FakeProjectRepository alloc] init];
    
    NSDate * start = self.clockView.timeStarted;
    
    [repo createTimesheetLog:start
                            :task.timeWorked
                            :task.taskDescription
                            :task.taskKey];
    
    [self goToParentController];
}

-(void)deleteClicked
{
    [self goToParentController];
}

- (void)goToParentController
{
    NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
    if( currentIndex-1 >= 0 )
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentIndex-1] animated:YES];
}

#pragma NSCoder

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    BOOL running = self.clockView.isClockRunning;
    [coder encodeBool:running forKey:@"IsClockRunning"];
    
    WorkTimerTask* runningTask = [self getRunningWorkTimerTask];
    [coder encodeObject:runningTask forKey:@"CurrentTask"];
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];

    _currentWorkTimerTask=[coder decodeObjectForKey:@"CurrentTask"];
    
    self.taskCodeLabel.text = _currentWorkTimerTask.taskKey;
    self.taskSummaryTextView.text = _currentWorkTimerTask.taskSummary;
    
    BOOL running = [coder decodeBoolForKey:@"IsClockRunning"];
    
    if(running)
       [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
}
@end
