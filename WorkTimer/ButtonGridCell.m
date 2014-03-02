//
//  ButtonGridCell.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "ButtonGridCell.h"

@implementation ButtonGridCell

@synthesize clockView = _clockView;

@synthesize alreadyStarted=_alreadyStarted;
@synthesize taskKeyLabel=_taskKeyLabel;
@synthesize comment=_comment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _alreadyStarted = false;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)startOrPause
{
    //We've started the timer so pause to go for lunch
    if(self.clockView.isClockRunning)
    {
        [self.stopButton setEnabled:NO];
        [self.clockView stop];
        
        [self.startOrPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    //We're back from lunch so start the timer again
    else
    {
        [self.stopButton setEnabled:YES];
        
        [self.clockView start];
        
        [self.startOrPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

-(void)tapCell:(BOOL) selected
{
    if(selected)
    {
        if(_alreadyStarted)
            [self startOrPause];
        else
            [self cellSelected];
    }
    else
    {
        [self startOrPause];
        [self cellDeselected];
    }
}

- (IBAction)startPauseTouchUpInside:(id)sender
{
    BOOL isPause = self.clockView.isClockRunning;
    if(isPause)
        [self tapCell:YES];
    else
        [self.delegate startClicked:isPause:self];
}


- (IBAction)stopTouchUpInside:(id)sender
{
    [self.delegate stopClicked:self];
}

- (void)paintCell:(UIColor*)color
{
    self.backgroundColor = color;
    self.taskKeyLabel.backgroundColor = color;
    
    self.taskSummaryLabel.backgroundColor = color;
}

- (void)cellSelected
{
    [self paintCell:[UIColor lightGrayColor]];
    
    [self.clockView.activityIndicator setHidden:false];
    [self startOrPause];
    
    _alreadyStarted=YES;
    
    [self showCommentPrompt];
}

- (void)cellDeselected
{
    [self paintCell:[UIColor whiteColor]];
    
    [_clockView.activityIndicator setHidden:TRUE];
    
    [self.clockView stop];
    [self.clockView reset];
    
    _alreadyStarted=false;
    
    [self.startOrPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.stopButton setEnabled:NO];
}

- (void)showCommentPrompt
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Description" message:@"Enter a description for this worklog" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _comment = [[alertView textFieldAtIndex:0] text];
}

#pragma NSCoder

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.alreadyStarted forKey:@"Selected"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    BOOL selected = [coder decodeBoolForKey:@"Selected"];
    
    if(selected)
        [self paintCell:[UIColor lightGrayColor]];
}

@end
