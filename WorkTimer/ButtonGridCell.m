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

-(void)tapCell:(BOOL) selected
{
    if(selected)
    {
        if(_alreadyStarted)
        {
            //We've started the timer so pause to go for lunch
            if(self.clockView.isClockRunning)
            {
                [self.clockView stop];
                [_clockView.activityIndicator stopAnimating];
            }
            //We're back from lunch so start the timer again
            else
            {
                [self.clockView start];
                [_clockView.activityIndicator startAnimating];
            }
        }
        else
            [self cellSelected];
    }
    else
    {
        [self cellDeselected];
    }
}

- (void)cellSelected
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.taskKeyLabel.backgroundColor = [UIColor lightGrayColor];
    
    self.taskSummaryLabel.backgroundColor = [UIColor lightGrayColor];
    
    [self.clockView.activityIndicator setHidden:false];
    [self.clockView.activityIndicator startAnimating];
    
    [self.clockView start];
    
    _alreadyStarted=YES;
    
    [self showCommentPrompt];
}

- (void)createTimesheetLog
{
    FakeProjectRepository *repo = [[FakeProjectRepository alloc] init];
    
    NSDate * start = _clockView.timeStarted;
    NSDate * logTime = _clockView.currentTime;
    
    [repo updateTask:_taskKeyLabel.text
                    :XMLParserTypeJIRAParser
                    :_comment
                    :start
                    :logTime];
}

- (void)cellDeselected
{
    self.backgroundColor = [UIColor whiteColor];
    self.taskKeyLabel.backgroundColor = [UIColor whiteColor];
    
    self.taskSummaryLabel.backgroundColor = [UIColor whiteColor];
    [_clockView.activityIndicator setHidden:TRUE];
    [_clockView.activityIndicator stopAnimating];
    [self.clockView stop];

    [self createTimesheetLog];
    
    [self.clockView reset];
    
    _alreadyStarted=false;
}

- (void)showCommentPrompt
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Description" message:@"Enter a description for this worklog" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _comment = [[alertView textFieldAtIndex:0] text];}

@end
