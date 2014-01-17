//
//  ProtocolProjectRepository.h
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolSettingsRepository <NSObject>

+ (NSString *) getMyUserName;
+ (NSString *) getToken:(NSInteger) parserType;
+ (NSString *) getServerPath:(NSInteger) parserType;
+ (NSString *) getAuthenticationToken:(NSInteger) parserType;

@end

