//
//  FakeProjectRepository.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolProjectRepository.h"
#import "FakeSettingsRepository.h"
#import "TaskParser.h"

@interface FakeProjectRepository : NSObject<ProtocolProjectRepository>

- (NSMutableArray *)getMyTasks:(int)numberOfDays;

- (NSString *)getURL:(NSInteger)numberOfDays
                    :(NSInteger)parserType;
@end
