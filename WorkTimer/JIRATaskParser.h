//
//  JIRATasksParser.h
//  WorkTimer
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
    WorkTimerTask *currentWorkTimerTask;
    BOOL storingCharacters;
    NSDateFormatter *parseFormatter;
    NSMutableData *xmlData;
    BOOL done;
    NSURLConnection *apiConnection;
}

@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) WorkTimerTask *currentWorkTimerTask;
@property (nonatomic, strong) NSDateFormatter *parseFormatter;
@property (nonatomic, strong) NSMutableData *xmlData;
@property (nonatomic, strong) NSURLConnection *apiConnection;

- (void)downloadAndParse:(NSURL *)url;

@end
