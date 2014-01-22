//
//  ProtocolProjectRepository.h
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@protocol ProtocolSettingsRepository <NSObject>

+ (NSString *) getMyUserName;
+ (NSString *) getServerPath;
+ (NSString *) getAuthenticationToken;
+ (NSInteger) getParserType;
+ (void) saveSettings:(Settings*) settings;
+ (void) closeSettingsDatabase;
@end

