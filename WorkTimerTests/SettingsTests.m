//
//  SettingsTests.m
//  WorkTimer
//
//  Created by martin steel on 21/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "SettingsTests.h"

@implementation SettingsTests

- (void)testValidateUserNameValid
{
    Settings* settings = [[Settings alloc]init];
    settings.userName = @"something";
    
    BOOL result = [settings isUserNameValid];
    STAssertTrue(result, @"User name should be valid");
}

- (void)testValidateUserNameInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.userName = @"";
    
    BOOL result = [settings isUserNameValid];
    STAssertFalse(result, @"User name should be invalid");
}

- (void)testValidatePasswordValid
{
    Settings* settings = [[Settings alloc]init];
    settings.password = @"something";
    
    BOOL result = [settings isPasswordValid];
    STAssertTrue(result, @"Password should be valid");
}

- (void)testValidatePasswordInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.password = @"";
    
    BOOL result = [settings isPasswordValid];
    STAssertFalse(result, @"Password should be invalid");
}

- (void)testValidateServerValid
{
    Settings* settings = [[Settings alloc]init];
    settings.serverPath = @"https://spaarks.atlassian.net";
    
    BOOL result = [settings isServerValid];
    STAssertTrue(result, @"Server should be valid");
}

- (void)testValidateServerInvalid
{
    Settings* settings = [[Settings alloc]init];
    settings.serverPath = @"";
    
    BOOL result = [settings isServerValid];
    STAssertFalse(result, @"Server should be invalid");
}

- (void)testValidateServerMissingHTTP
{
    Settings* settings = [[Settings alloc]init];
    settings.serverPath = @"spaarks.atlassian.net";
    
    BOOL result = [settings isServerValid];
    STAssertFalse(result, @"Server should be invalid");
}


-(void)testAuthenticationToken
{
    Settings* settings = [[Settings alloc] init];
    settings.userName = @"First.last@company.com";
    settings.password = @"P4ssw0rd1#";
    
    NSString* expected = @"Rmlyc3QubGFzdEBjb21wYW55LmNvbTpQNHNzdzByZDEj";
    
    STAssertEqualObjects(expected, settings.authenticationToken, @"Authentication Token should be Rmlyc3QubGFzdEBjb21wYW55LmNvbTpQNHNzdzByZDEj");
}

@end
