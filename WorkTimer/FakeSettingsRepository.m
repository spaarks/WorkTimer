//
//  FakeSettingsRepository.m
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "FakeSettingsRepository.h"

@implementation FakeSettingsRepository

+ (NSString *) getMyUserName
{
    return @"martin.steel@spaarks.com";
}

+ (NSString *) getToken:(NSInteger) parserType
{
    return @"c39f740a-69dd-4ccc-a21e-820ae0f9d7f2";
}

+ (NSString *) getServerPath:(NSInteger) parserType
{
    return @"https://spaarks.atlassian.net";
}

+ (NSString *) getAuthenticationToken:(NSInteger) parserType
{
    return @"bWFydGluLnN0ZWVsQHNwYWFya3MuY29tOlllbGxvdzEy";
}

@end
