//
//  SettingsTests.m
//  WorkTimer
//
//  Created by martin steel on 21/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "Settings.h"

@interface SettingsTests : XCTestCase
@end

@implementation SettingsTests

- (void)testValidateUserNameValid
{
    Settings* settings = [[Settings alloc]init];
    settings.userName = @"something";
    
    BOOL result = [settings isUserNameValid];
    XCTAssertTrue(result, @"User name should be valid");
}

- (void)testValidateUserNameInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.userName = @"";
    
    BOOL result = [settings isUserNameValid];
    XCTAssertFalse(result, @"User name should be invalid");
}

- (void)testValidatePasswordValid
{
    Settings* settings = [[Settings alloc]init];
    settings.password = @"something";
    
    BOOL result = [settings isPasswordValid];
    XCTAssertTrue(result, @"Password should be valid");
}

- (void)testValidatePasswordInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.password = @"";
    
    BOOL result = [settings isPasswordValid];
    XCTAssertFalse(result, @"Password should be invalid");
}

- (void)testValidateServerValid
{
    Settings* settings = [[Settings alloc]init];
    settings.serverPath = @"https://spaarks.atlassian.net";
    
    BOOL result = [settings isServerValid];
    XCTAssertTrue(result, @"Server should be valid");
}

- (void)testValidateServerInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.serverPath = @"";
    
    BOOL result = [settings isServerValid];
    XCTAssertFalse(result, @"Server should be invalid");
}

- (void)testValidateTempoTokenValid
{
    Settings* settings = [[Settings alloc]init];
    settings.tempoToken = @"c39f740a-69dd-4ccc-a21e-820ae0f9d7f2";
    
    BOOL result = [settings isTempoTokenValid];
    XCTAssertTrue(result, @"TempoToken should be valid");
}

- (void)testValidateTempoTokenInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.tempoToken = @"";
    
    BOOL result = [settings isTempoTokenValid];
    XCTAssertFalse(result, @"TempoToken should be invalid");
}


- (void)testValidateServerMissingHTTP
{
    Settings* settings = [[Settings alloc]init];
    settings.serverPath = @"spaarks.atlassian.net";
    
    BOOL result = [settings isServerValid];
    XCTAssertFalse(result, @"Server should be invalid");
}


-(void)testAuthenticationToken
{
    Settings* settings = [[Settings alloc] init];
    settings.userName = @"First.last@company.com";
    settings.password = @"P4ssw0rd1#";
    
    NSString* expected = @"Rmlyc3QubGFzdEBjb21wYW55LmNvbTpQNHNzdzByZDEj";
    
    XCTAssertEqualObjects(expected, settings.authenticationToken, @"Authentication Token should be Rmlyc3QubGFzdEBjb21wYW55LmNvbTpQNHNzdzByZDEj");
}

@end
