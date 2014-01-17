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
    
    NSString *startDateString = [Helpers getStartDateString];
    NSString *endDateString = [Helpers getEndDateString];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/plugins/servlet/tempo-getWorklog/?dateFrom=%@&dateTo=%@&format=xml&addWorklogDetails=falsel&addIssueSummary=true&diffOnly=false&userName=%@&tempoApiToken=%@", baseURL, startDateString, endDateString, userName, token];
    return urlString;
}

- (void)SetAuthenticationType:(NSInteger)parserType request:(NSMutableURLRequest *)request
{
    NSString* token = [FakeSettingsRepository getAuthenticationToken:(parserType)];
    NSString * headerValue = [NSString stringWithFormat:@"Basic %@", token];
    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
}

- (NSData*)GetJSONDataForRequest:(NSDate*)_timeStarted
                                :(NSString*)comment
                                :(NSDate*)timeToLog
{
    NSString *timeStartedString = [Helpers getDateString:_timeStarted];
    NSString *timeTakenString = [Helpers getJIRATimeString:timeToLog];
    
    NSDictionary *dict = @{
                           @"timeSpent":timeTakenString,
                           @"started":timeStartedString,
                           @"comment":comment};
    
    NSError *error;
    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
}
                                 
- (void)updateTask:(NSString*)taskID
                        :(NSInteger)parserType
                        :(NSString*)comment
                        :(NSDate*)_timeStarted
                        :(NSDate*)timeToLog
{
    NSData *jsonData = [self GetJSONDataForRequest:_timeStarted :comment:timeToLog];

    NSString* serverPath = [FakeSettingsRepository getServerPath:(parserType)];
    NSString* urlPath = [NSString stringWithFormat:@"%@/rest/api/latest/issue/%@/worklog", serverPath, taskID];
    
    NSURL *url = [NSURL URLWithString:urlPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:jsonData];
    
    NSError *error;
    NSArray *jsonArry = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSLog(@"%@",jsonArry);
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [self SetAuthenticationType:parserType request:request];
    
    //__block NSString *html;
    
    [NSURLConnection sendAsynchronousRequest:request
                                            queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *rsp, NSData *data, NSError *err) {
        //NSLog(@"POST sent!");
        //html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }];
}

@end
