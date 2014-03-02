//
//  JIRASettingsRepository.h
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "ProtocolSettingsRepository.h"
#import "Settings.h"
#import "WorkTimerTask.h"

@interface Repository : NSObject<ProtocolSettingsRepository>

+ (Settings*) getSettings;
+ (WorkTimerTask*) getWorkTimerTask;

+ (void) saveSettings:(Settings*) settings;
+ (void) saveWorkTimerTask:(WorkTimerTask*) workTimerTask;

+ (BOOL) doSettingsExist;
+ (void) closeSettingsDatabase;
+ (void) resetDatabase;


@end
