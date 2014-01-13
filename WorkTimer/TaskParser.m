//
//  TaskParser2.m
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "TaskParser.h"
#import "WorkTimerTask.h"

static NSUInteger kCountForNotification = 10;

@implementation TaskParser

@synthesize delegate, parsedWorkTrackerTasks, startTimeReference, downloadStartTimeReference, parseDuration, downloadDuration, totalDuration;

+ (NSString *)parserName {
    NSAssert((self != [TaskParser class]), @"Class method parserName not valid for abstract base class TaskParser");
    return @"Base Class";
}

+ (XMLParserType)parserType {
    NSAssert((self != [TaskParser class]), @"Class method parserType not valid for abstract base class TaskParser");
    return XMLParserTypeAbstract;
}

- (void)start {
    self.startTimeReference = [NSDate timeIntervalSinceReferenceDate];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.parsedWorkTrackerTasks = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:@"https://spaarks.atlassian.net/plugins/servlet/tempo-getWorklog/?dateFrom=2013-12-01&dateTo=2013-12-31&format=xml&addWorklogDetails=falsel&addIssueSummary=true&diffOnly=false&userName=martin.steel@spaarks.com&tempoApiToken=c39f740a-69dd-4ccc-a21e-820ae0f9d7f2"];
    [NSThread detachNewThreadSelector:@selector(downloadAndParse:) toTarget:self withObject:url];
}


- (void)downloadAndParse:(NSURL *)url {
    NSAssert([self isMemberOfClass:[TaskParser class]] == NO, @"Object is of abstract base class TaskParser");
}

- (void)downloadStarted {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    self.downloadStartTimeReference = [NSDate timeIntervalSinceReferenceDate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)downloadEnded {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - self.downloadStartTimeReference;
    downloadDuration += duration;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)parseEnded {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didParseWorkTrackerTasks:)] && [parsedSongs count] > 0) {
        [self.delegate parser:self didParseWorkTrackerTasks:parsedWorkTrackerTasks];    
    }
    [self.parsedWorkTrackerTasks removeAllObjects];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parserDidEndParsingData:)]) {
        [self.delegate parserDidEndParsingData:self];
    }
    //NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
    //totalDuration = duration;
    //WriteStatisticToDatabase([[self class] parserType], downloadDuration, parseDuration, totalDuration);
}

- (void)parsedWorkTrackerTask:(WorkTimerTask *)workTrackerTask{
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [self.parsedWorkTrackerTasks addObject:workTrackerTask];
    if (self.parsedWorkTrackerTasks.count > kCountForNotification) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didParseWorkTrackerTasks:)]) {
            [self.delegate parser:self didParseWorkTrackerTasks:parsedWorkTrackerTasks];
        }
        [self.parsedWorkTrackerTasks removeAllObjects];
    }
}

- (void)parseError:(NSError *)error {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [self.delegate parser:self didFailWithError:error];
    }
}

- (void)addToParseDuration:(NSNumber *)duration {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    parseDuration += [duration doubleValue];
}

@end
