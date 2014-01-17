//
//  ClockViewController.m
//  WorkTimer
//
//  Created by martin steel on 15/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "ClockView.h"

@implementation ClockView

@synthesize timeString=_timeString;
@synthesize currentTime=_currentTime;
@synthesize started=_started;
@synthesize isClockRunning=_isClockRunning;
@synthesize timeStarted=_timeStarted;

-(id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _started = NO;
    }
    return self;
    //c2
}

- (void) start
{
    [self tick:nil];
    _isClockRunning = YES;
}

- (void) stop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tick:)  object:nil];
    _isClockRunning = NO;
}

- (void) reset
{
    _timeString.text=@"";
}

- (void)initializeTimer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *dateTimer  = [dateFormatter dateFromString:@"00:00:00"];
    
    _currentTime = dateTimer;
    _timeStarted = [NSDate date];
    _started=YES;
}

- (void) tick:(id)sender
{
    if(_started)
        _currentTime = [_currentTime dateByAddingTimeInterval:1];
    else
        [self initializeTimer];
    
    _timeString.text = [Helpers getTimerString:_currentTime];
    
    [self performSelector: @selector(tick:)
               withObject: nil
               afterDelay: 1.0
     ];
}
@end
