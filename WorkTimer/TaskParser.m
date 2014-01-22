//
//  TaskParser2.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "TaskParser.h"

static NSUInteger kCountForNotification = 10;

@implementation TaskParser

@synthesize delegate, parsedWorkTimerTasks;

+ (NSString *)parserName {
    NSAssert((self != [TaskParser class]), @"Class method parserName not valid for abstract base class TaskParser");
    return @"Base Class";
}

+ (XMLParserType)parserType {
    NSAssert((self != [TaskParser class]), @"Class method parserType not valid for abstract base class TaskParser");
    return XMLParserTypeAbstract;
}

- (void)start {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.parsedWorkTimerTasks = [NSMutableArray array];
 
    FakeProjectRepository *repo = [[FakeProjectRepository alloc] init];
    NSInteger numberOfDays = 20;
    NSString* urlString = [repo getURL:numberOfDays
                                      :XMLParserTypeJIRAParser];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [NSThread detachNewThreadSelector:@selector(downloadAndParse:) toTarget:self withObject:url];
}


- (void)downloadAndParse:(NSURL *)url {
    NSAssert([self isMemberOfClass:[TaskParser class]] == NO, @"Object is of abstract base class TaskParser");
}

- (void)downloadStarted {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)downloadEnded {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)parseEnded {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didParseWorkTimerTasks:)] && [parsedWorkTimerTasks count] > 0) {
        [self.delegate parser:self didParseWorkTimerTasks:parsedWorkTimerTasks];
    }
    [self.parsedWorkTimerTasks removeAllObjects];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parserDidEndParsingData:)]) {
        [self.delegate parserDidEndParsingData:self];
    }
}

- (void)parsedWorkTimerTask:(WorkTimerTask *)WorkTimerTask{
    
    [self.parsedWorkTimerTasks addObject:WorkTimerTask];
    if (self.parsedWorkTimerTasks.count > kCountForNotification) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didParseWorkTimerTasks:)]) {
            [self.delegate parser:self didParseWorkTimerTasks:parsedWorkTimerTasks];
        }
        [self.parsedWorkTimerTasks removeAllObjects];
    }
}

- (void)parseError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [self.delegate parser:self didFailWithError:error];
    }
}

@end
