//
//  ProtocolProjectRepository.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskParser.h"

@protocol ProtocolProjectRepository <NSObject>

//Fetch Tasks from the last number of days excluding today.
- (NSString *)getURL:(NSInteger)parserType;

- (void)createTimesheetLog:(NSDate*) timeStarted
                          :(NSString*) logTime
                          :(NSString*) comment
                          :(NSString*) taskKey;
@end

