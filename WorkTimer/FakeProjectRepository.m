//
//  FakeProjectRepository.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "FakeProjectRepository.h"

@implementation FakeProjectRepository

- (NSMutableArray *)getMyTasks:(int)numberOfDays;
{
    NSMutableArray * dummy = [[NSMutableArray alloc] init];
    return dummy;
}
- (NSString *)getURL:(NSInteger)numberOfDays
                    :(NSInteger)parserType{
    NSString *baseURL = [FakeSettingsRepository getServerPath:(parserType)];
    NSString *userName = [FakeSettingsRepository getMyUserName];
    NSString *token = [FakeSettingsRepository getToken:(parserType)];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/plugins/servlet/tempo-getWorklog/?dateFrom=2013-12-01&dateTo=2013-12-31&format=xml&addWorklogDetails=falsel&addIssueSummary=true&diffOnly=false&userName=%@&tempoApiToken=%@", baseURL, userName, token];
    return urlString;
}

- (void)test:(XMLParserType)parserType{return;}
@end
