//
//  ProtocolProjectRepository.h
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolProjectRepository <NSObject>

//Fetch Tasks from the last number of days excluding today.
- (NSMutableArray *)getMyTasks(int)numberOfDays;

@end

