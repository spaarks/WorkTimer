#import "ClockView.h"

@implementation ClockView

@synthesize timeString=_timeString;
@synthesize currentTime=_currentTime;
@synthesize started=_started;
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
    _started=NO;
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

#pragma NSCoder

//-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    //[coder encodeObject:self.workTimerTasks forKey:@"WorkTimerTasks"];
//    [coder encodeObject:_timeStarted forKey:@"TimeStarted"];
//    [coder encodeBool:_isClockRunning forKey:@"IsClockRunning"];
//    [coder encodeObject:_currentTime forKey:@"CurrentTime"];
//    [coder encodeBool:_started forKey:@"Started"];
//    
//    BOOL isActivityIndicaterAnimating = [_activityIndicator isAnimating];
//    [coder encodeBool:isActivityIndicaterAnimating forKey:@"ActivityAnimating"];
//
//    [super encodeRestorableStateWithCoder:coder];
//}
//
//-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    [super decodeRestorableStateWithCoder:coder];
//
//    _timeStarted = [coder decodeObjectForKey:@"TimeStarted"];
//    _isClockRunning = [coder decodeBoolForKey:@"IsClockRunning"];
//    _currentTime = [coder decodeObjectForKey:@"CurrentTime"];
//    _started = [coder decodeBoolForKey:@"Started"];
//    
//    BOOL animating = [coder decodeBoolForKey:@"ActivityAnimating"];
//    
//    if(animating)
//        [_activityIndicator startAnimating];
//    else
//        [_activityIndicator stopAnimating];
//}

@end
