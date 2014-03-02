//
//  SettingsRepository.m
//  WorkTimer
//
//  Created by martin steel on 22/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "RepositoryTests.h"

@implementation RepositoryTests

-(Settings*)getSettings
{
    Settings* settings = [[Settings alloc] init];
    settings.userName = @"First.last@company.com";
    settings.password = @"P4ssw0rd1#";
    settings.serverPath = @"http://test.atlassian.co.uk";
    settings.parserType=0;
    
    return settings;
}

- (void)testSaveSettings
{
    //Reset database
    //Save settings
    //Fetch settings
    //Check results
    //Reset database
    
    [Repository resetDatabase];
    Settings* testSettings = [self getSettings];
    [Repository saveSettings:testSettings];
    
    Settings* retrievedSettings = [Repository getSettings];

    STAssertEqualObjects(testSettings.userName, retrievedSettings.userName, @"User name should be First.last@company.com");
    STAssertEqualObjects(testSettings.password, retrievedSettings.password, @"Password should be P4ssw0rd1#");
    STAssertEqualObjects(testSettings.serverPath, retrievedSettings.serverPath, @"Server path should be http://test.atlassian.co.uk");
    
    STAssertEquals(testSettings.parserType, retrievedSettings.parserType, @"Parser type should be 0");
    
    [Repository resetDatabase];
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
    
    [Repository resetDatabase];
    WorkTimerTask* testSaveWorkTimerTask = [self getWorkTimerTask];
    [Repository saveWorkTimerTask:testSaveWorkTimerTask];
    
    WorkTimerTask* retrievedWorkTimerTask = [Repository getWorkTimerTask];
    
    STAssertEqualObjects(testSaveWorkTimerTask.taskID, retrievedWorkTimerTask.taskID, @"TaskID should be 12229");
    STAssertEqualObjects(testSaveWorkTimerTask.taskKey, retrievedWorkTimerTask.taskKey, @"TaskKey should be BMSCCHANGE-33");
    STAssertEqualObjects(testSaveWorkTimerTask.taskSummary, retrievedWorkTimerTask.taskSummary, @"Task Summary shoud be Meeting Internal");
    STAssertEqualObjects(testSaveWorkTimerTask.taskDescription, retrievedWorkTimerTask.taskDescription, @"Description should be 'Did some work'");
    STAssertEqualObjects(testSaveWorkTimerTask.timeWorked, retrievedWorkTimerTask.timeWorked, @"Time worked should be 01h 35m");
    
    [Repository resetDatabase];
}


@end
