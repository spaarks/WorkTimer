//
//  SettingsRepository.m
//  WorkTimer
//
//  Created by martin steel on 22/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Settings.h"
#import "LocalRepository.h"

@interface RepositoryTests : XCTestCase

@end

@implementation RepositoryTests

-(Settings*)getSettings
{
    Settings* settings = [[Settings alloc] init];
    settings.userName = @"First.last@company.com";
    settings.password = @"P4ssw0rd1#";
    settings.serverPath = @"http://test.atlassian.co.uk";
    settings.parserType=0;
    settings.tempoToken = @"c39f740a-69dd-4ccc-a21e-820ae0f9d7f2";
    
    return settings;
}

- (void)testSaveSettings
{
    //Reset database
    //Save settings
    //Fetch settings
    //Check results
    //Reset database
    
    [LocalRepository resetDatabase];
    Settings* testSettings = [self getSettings];
    [LocalRepository saveSettings:testSettings];
    
    Settings* retrievedSettings = [LocalRepository getSettings];

    XCTAssertEqualObjects(testSettings.userName, retrievedSettings.userName, @"User name should be First.last@company.com");
    XCTAssertEqualObjects(testSettings.password, retrievedSettings.password, @"Password should be P4ssw0rd1#");
    XCTAssertEqualObjects(testSettings.serverPath, retrievedSettings.serverPath, @"Server path should be http://test.atlassian.co.uk");
    
    XCTAssertEqual(testSettings.parserType, retrievedSettings.parserType, @"Parser type should be 0");
    
    XCTAssertEqualObjects(testSettings.tempoToken, retrievedSettings.tempoToken, @"tempo token should be c39f740a-69dd-4ccc-a21e-820ae0f9d7f2");

    [LocalRepository resetDatabase];
}

-(WorkTimerTask*)getWorkTimerTask
{
    WorkTimerTask* workTimerTask = [[WorkTimerTask alloc] init];
    workTimerTask.taskID = @"12229";
    workTimerTask.taskKey = @"BMSCCHANGE-33";
    workTimerTask.taskSummary = @"Meeting Internal";
    workTimerTask.taskDescription = @"Did some work";
    workTimerTask.timeWorked = @"01h 35m";
    
    return workTimerTask;
}

- (void)testSaveWorkTimerTask
{
    //Reset database
    //Save workTimerTask
    //Fetch workTimerTask
    //Check results
    //Reset database
    
    [LocalRepository resetDatabase];
    WorkTimerTask* testSaveWorkTimerTask = [self getWorkTimerTask];
    [LocalRepository saveWorkTimerTask:testSaveWorkTimerTask];
    
    WorkTimerTask* retrievedWorkTimerTask = [LocalRepository getWorkTimerTask];
    
    XCTAssertEqualObjects(testSaveWorkTimerTask.taskID, retrievedWorkTimerTask.taskID, @"TaskID should be 12229");
    XCTAssertEqualObjects(testSaveWorkTimerTask.taskKey, retrievedWorkTimerTask.taskKey, @"TaskKey should be BMSCCHANGE-33");
    XCTAssertEqualObjects(testSaveWorkTimerTask.taskSummary, retrievedWorkTimerTask.taskSummary, @"Task Summary shoud be Meeting Internal");
    XCTAssertEqualObjects(testSaveWorkTimerTask.taskDescription, retrievedWorkTimerTask.taskDescription, @"Description should be 'Did some work'");
    XCTAssertEqualObjects(testSaveWorkTimerTask.timeWorked, retrievedWorkTimerTask.timeWorked, @"Time worked should be 01h 35m");
    
    [LocalRepository resetDatabase];
}


@end
