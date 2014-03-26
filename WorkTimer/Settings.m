//
//  Settings.m
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "Settings.h"

@implementation Settings

NSString* _userName;
NSString* _password;
@synthesize serverPath = _serverPath;
@synthesize authenticationToken = _authenticationToken;
@synthesize tempoToken = _tempoToken;

-(NSString*)calculateAuthenticationToken
{
    NSString* unencoded = [NSString stringWithFormat:@"%@:%@", _userName, _password];
    NSString* encoded = [Helpers encodeString:unencoded];
    
    return _authenticationToken = encoded;
}

- (NSString*) getPassword
{
    return _password;
}

- (void) setPassword:(NSString *)password_
{
    _password=password_;
    if(_userName != nil)
        [self calculateAuthenticationToken];
}

- (NSString*) getUserName
{
    return _userName;
}

- (void) setUserName:(NSString *)userName_
{
    _userName=userName_;
    if(_password != nil)
        [self calculateAuthenticationToken];
}

////TODO refactor this method out so that tempo token is no longer used
//- (NSString *) getToken
//{
//    return @"^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$";
//}

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

-(BOOL)isTempoTokenValid
{
    NSString *urlRegEx =
    @"^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL result= [urlTest evaluateWithObject:_tempoToken];
    return result;
}

-(BOOL)areSettingsValid
{
    return
        [self isUserNameValid] &&
        [self isPasswordValid] &&
        [self isServerValid] &&
        [self isTempoTokenValid];
 }
@end
