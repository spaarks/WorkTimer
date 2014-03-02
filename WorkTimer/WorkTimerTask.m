//
//  WorkTimerTask.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "WorkTimerTask.h"

@implementation WorkTimerTask

-(NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.taskID hash];
    
    return result;
}

-(BOOL)isEqual:(id)object
{
    return [self.taskID isEqualToString:[object taskID]];
}

//Validate the time worked properly
//Add tests for the validators
-(BOOL)isTimeWorkedValid
{
    return _timeWorked.length>0;
}

-(BOOL)isDescriptionValid
{
    return _taskDescription.length>0;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"WorkTimerTask: taskID=%@ taskKey='%@' taskSummary='%@' description='%@' timeWorked='%@'", _taskID, _taskKey, _taskSummary, _taskDescription, _timeWorked];
}

#pragma NSCoder

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: [self taskID] forKey: @"taskID"];
    [coder encodeObject: [self taskKey] forKey: @"taskKey"];
    [coder encodeObject: [self taskSummary] forKey: @"taskSummary"];
}

- (id)initWithCoder: (NSCoder *)coder
{
    if((self = [self init]))
    {
        _taskID = [coder decodeObjectForKey: @"taskID"];
        _taskKey = [coder decodeObjectForKey: @"taskKey"];
        _taskSummary = [coder decodeObjectForKey: @"taskSummary"];
    }
    return self;
}

@end
