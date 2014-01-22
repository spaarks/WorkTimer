//
//  SettingsRepository.m
//  WorkTimer
//
//  Created by martin steel on 22/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "SettingsRepositoryTests.h"

@implementation SettingsRepositoryTests

-(Settings*)getSettings
{
    Settings* settings = [[Settings alloc] init];
    settings.userName = @"First.last@company.com";
    settings.password = @"P4ssw0rd1#";
    settings.serverPath = @"http://test.atlassian.co.uk";
    settings.parserType=0;
    [settings calculateAuthenticationToken];
    
    return settings;
}

- (void)testSaveSettings
{
    //Reset database
    //Save settings
    //Fetch settings
    //Check results
    //Reset database
    
    [SettingsRepository resetSettingsDatabase];
    Settings* testSettings = [self getSettings];
    [SettingsRepository saveSettings:testSettings];
    
    Settings* retrievedSettings = [SettingsRepository getSettings];

    STAssertEqualObjects(testSettings.userName, retrievedSettings.userName, @"User name should be First.last@company.com");
    STAssertEqualObjects(testSettings.password, retrievedSettings.password, @"Password should be P4ssw0rd1#");
    STAssertEqualObjects(testSettings.serverPath, retrievedSettings.serverPath, @"Server path should be http://test.atlassian.co.uk");
    
    STAssertEquals(testSettings.parserType, retrievedSettings.parserType, @"Parser type should be 0");
    
    [SettingsRepository resetSettingsDatabase];
}


@end
