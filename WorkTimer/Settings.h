//
//  Settings.h
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helpers.h"

@interface Settings : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *serverPath;
@property NSInteger parserType;
@property (nonatomic, copy) NSString *authenticationToken;

-(NSString*)calculateAuthenticationToken;
-(BOOL)isUserNameValid;
-(BOOL)isPasswordValid;
-(BOOL)isServerValid;

@end
