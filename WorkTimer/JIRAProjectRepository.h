//
//  FakeProjectRepository.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolProjectRepository.h"
#import "SettingsRepository.h"
#import "TaskParser.h"
#import "Helpers.h"

@interface JIRAProjectRepository : NSObject<ProtocolProjectRepository>

- (NSString *)getURL:(NSInteger)parserType;

- (void)createTimesheetLog:(NSDate*) timeStarted
                          :(NSString*) logTime
                          :(NSString*) comment
                          :(NSString*) taskKey;

@end
