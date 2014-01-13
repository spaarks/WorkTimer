//
//  JIRATasksParser.h
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkTimerTask.h"
#import "TaskParser.h"

@interface JIRATaskParser : TaskParser <NSXMLParserDelegate>
{
    NSMutableString *currentString;
    WorkTimerTask *currentWorkTrackerTask;
    BOOL storingCharacters;
    NSDateFormatter *parseFormatter;
    NSMutableData *xmlData;
    BOOL done;
    NSURLConnection *apiConnection;
}

@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) WorkTimerTask *currentWorkTrackerTask;
@property (nonatomic, strong) NSDateFormatter *parseFormatter;
@property (nonatomic, strong) NSMutableData *xmlData;
@property (nonatomic, strong) NSURLConnection *apiConnection;

- (void)downloadAndParse:(NSURL *)url;

@end
