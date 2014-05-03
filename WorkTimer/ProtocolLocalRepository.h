//
//  ProtocolProjectRepository.h
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@protocol ProtocolLocalRepository <NSObject>

+ (Settings*) getSettings;

+ (void) saveSettings:(Settings*) settings;
+ (BOOL) doSettingsExist;
+ (void) closeSettingsDatabase;
+ (void) resetDatabase;
@end

