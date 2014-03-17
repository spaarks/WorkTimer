#import "ClockView.h"

@implementation ClockView

@synthesize timeString=_timeString;
@synthesize currentTime=_currentTime;
@synthesize isStarted=_isStarted;
@synthesize isClockRunning=_isClockRunning;
@synthesize timeStarted=_timeStarted;
@synthesize activityIndicator=_activityIndicator;

- (void) start
{
    [_activityIndicator startAnimating];
    [self tick:nil];
    _isClockRunning = YES;
}

- (void) stop
{
    [_activityIndicator stopAnimating];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tick:)  object:nil];
    _isClockRunning = NO;
}

- (void) reset
{
    _timeString.text=@"";
    _isStarted=NO;
}

- (void)initializeTimer
{
    _currentTime = [Helpers getTimeFromString:@"00:00:00"];
    _timeStarted = [NSDate date];
    _isStarted=YES;
}

- (void) tick:(id)sender
{
    if(_isStarted)
        _currentTime = [_currentTime dateByAddingTimeInterval:1];
    else
        [self initializeTimer];
    
    _timeString.text = [Helpers getTimerString:_currentTime];
    
    [self performSelector: @selector(tick:)
               withObject: nil
               afterDelay: 1.0
     ];
}

#pragma NSCoder

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    //[coder encodeObject:self.workTimerTasks forKey:@"WorkTimerTasks"];
    [coder encodeObject:_timeStarted forKey:@"TimeStarted"];
    [coder encodeBool:_isClockRunning forKey:@"IsClockRunning"];
    [coder encodeObject:_currentTime forKey:@"CurrentTime"];
    [coder encodeBool:_isStarted forKey:@"IsStarted"];
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];

    _timeStarted = [coder decodeObjectForKey:@"TimeStarted"];
    _isClockRunning = [coder decodeBoolForKey:@"IsClockRunning"];
    _isStarted = [coder decodeBoolForKey:@"IsStarted"];
    
    if(_isClockRunning)
    {
        NSString* timeNowString = [Helpers getDifferenceString:_timeStarted :[NSDate date]];
        _currentTime = [Helpers getTimeFromString:timeNowString];
        [self tick:nil];
    }
    else
    {
        _currentTime = [coder decodeObjectForKey:@"CurrentTime"];
    }
        
    _timeString.text = [Helpers getTimerString:_currentTime];    
}

@end
