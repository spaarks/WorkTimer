//
//  Settings.m
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize userName = _userName;
@synthesize password = _password;
@synthesize serverPath = _serverPath;
@synthesize authenticationToken = _authenticationToken;

-(NSString*)calculateAuthenticationToken
{
    NSString* unencoded = [NSString stringWithFormat:@"%@:%@", _userName, _password];
    NSString* encoded = [Helpers encodeString:unencoded];
    
    return _authenticationToken = encoded;
}

//TODO refactor this method out so that tempo token is no longer used
- (NSString *) getToken
{
    return @"c39f740a-69dd-4ccc-a21e-820ae0f9d7f2";
}

-(BOOL)isUserNameValid
{
    return _userName.length>0;
}

-(BOOL)isPasswordValid
{
    return _password.length>0;
}

-(BOOL)isServerValid
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL result= [urlTest evaluateWithObject:_serverPath];
    return result;
}

-(BOOL)areSettingsValid
{
    return
        [self isUserNameValid] &&
        [self isPasswordValid] &&
        [self isServerValid];
 }
@end
