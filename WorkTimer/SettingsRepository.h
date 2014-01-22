//
//  JIRASettingsRepository.h
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolSettingsRepository.h"
#import "Settings.h"
#import <sqlite3.h>

@interface SettingsRepository : NSObject<ProtocolSettingsRepository>

+ (Settings*) getSettings;

+ (void) saveSettings:(Settings*) settings;
+ (BOOL) doSettingsExist;
+ (void) closeSettingsDatabase;
+ (void) resetSettingsDatabase;


@end
