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
    return _description.length>0;
}

@end
