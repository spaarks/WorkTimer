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
        [self.clockView stop];
        
        [self.startOrPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    //We're back from lunch so start the timer again
    else
    {
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
    
//    if(!_alreadyStarted)
//    {
//        UICollectionView* collectionView = [(ButtonGridViewController*)self.superview collectionView];
//        NSIndexPath *indexPath = [collectionView indexPathForCell:self];
//        NSNumber* cellIndex = [NSNumber numberWithInt:[indexPath indexAtPosition:1]];
//        
//        //If we are clicking start for the first time then remove any deselected cells from the selection list
//        //and call cellDeselected for them
//    }
//    
//    [self tapCell:true];
}


- (IBAction)stopTouchUpInside:(id)sender
{
    [self.delegate stopClicked:self];
    
    //UICollectionView* collectionView = [(ButtonGridViewController*)self.superview collectionView];
    //[collectionView selectItemAtIndexPath:<#(NSIndexPath *)#> animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    //[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)cellSelected
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.taskKeyLabel.backgroundColor = [UIColor lightGrayColor];
    
    self.taskSummaryLabel.backgroundColor = [UIColor lightGrayColor];
    
    [self.clockView.activityIndicator setHidden:false];
    [self startOrPause];
    
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
