//
//  FakeProjectRepository.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "JIRAProjectRepository.h"

@implementation JIRAProjectRepository

- (NSString *)getURL:(NSInteger)parserType
{
    Settings* currentSettings = [SettingsRepository getSettings];
    
    NSString *baseURL = currentSettings.serverPath;
    NSString *userName = currentSettings.userName;
    NSString *token = currentSettings.tempoToken;
    
    NSString *startDateString = [Helpers getStartDateString];
    NSString *endDateString = [Helpers getEndDateString];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/plugins/servlet/tempo-getWorklog/?dateFrom=%@&dateTo=%@&format=xml&addWorklogDetails=falsel&addIssueSummary=true&diffOnly=false&userName=%@&tempoApiToken=%@", baseURL, startDateString, endDateString, userName, token];
    return urlString;
}

- (void)setAuthenticationType:(NSInteger)parserType request:(NSMutableURLRequest *)request
{
    Settings* currentSettings = [SettingsRepository getSettings];
    NSString* token = currentSettings.authenticationToken;
    
    NSString * headerValue = [NSString stringWithFormat:@"Basic %@", token];
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
}

- (NSData*)getJSONDataForRequest:(NSDate*)_timeStarted
                                :(NSString*)comment
                                :(NSString*)timeToLog
{
    NSString *timeStartedString = [Helpers getDateString:_timeStarted];
    
    NSDictionary *dict = @{
                           @"timeSpent":timeToLog,
                           @"started":timeStartedString,
                           @"comment":comment};
    
    NSError *error;
    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
}

- (void)createTimesheetLog:(NSDate*) timeStarted
                          :(NSString*) logTime
                          :(NSString*) comment
                          :(NSString*) taskKey
{
    JIRAProjectRepository *repo = [[JIRAProjectRepository alloc] init];
    
    [repo updateTask:taskKey
                    :XMLParserTypeJIRAParser
                    :comment
                    :timeStarted
                    :logTime];
}
                                 
- (void)updateTask:(NSString*)taskID
                        :(NSInteger)parserType
                        :(NSString*)comment
                        :(NSDate*)_timeStarted
                        :(NSString*)timeToLog
{
    NSData *jsonData = [self getJSONDataForRequest:_timeStarted :comment:timeToLog];

    Settings* currentSettings = [SettingsRepository getSettings];
    
    NSString* serverPath = currentSettings.serverPath;
    NSString* urlPath = [NSString stringWithFormat:@"%@/rest/api/latest/issue/%@/worklog", serverPath, taskID];
    
    NSURL *url = [NSURL URLWithString:urlPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:jsonData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [self setAuthenticationType:parserType request:request];
    
    __block NSString *html;
    
    [NSURLConnection sendAsynchronousRequest:request
                                            queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *rsp, NSData *data, NSError *err) {
        html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }];
}

@end
