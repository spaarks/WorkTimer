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
@end
