//
//  ParseTasks.h
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkTimerTask.h"

typedef enum {
    XMLParserTypeAbstract = -1,
    XMLParserTypeJIRAParser = 0,
    XMLParserTypeHarvestParser = 1
} XMLParserType;

@class TaskParser;

@protocol ProtocolTaskParserDelegate <NSObject>

@optional
// Called by the parser when parsing is finished.
- (void)parserDidEndParsingData:(TaskParser *)parser;
// Called by the parser in the case of an error.
- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error;
// Called by the parser when one or more songs have been parsed. This method may be called multiple times.
- (void)parser:(TaskParser *)parser didParseWorkTrackerTasks:(NSArray *)parsedWorkTrackerTasks;

@end

#pragma mark -

@interface TaskParser : NSObject {
    id <ProtocolTaskParserDelegate> __weak delegate;
    NSMutableArray *parsedSongs;
    // This time interval is used to measure the overall time the parser takes to download and parse XML.
    NSTimeInterval startTimeReference;
    NSTimeInterval downloadStartTimeReference;
    double parseDuration;
    double downloadDuration;
    double totalDuration;
}

@property (nonatomic, weak) id <ProtocolTaskParserDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *parsedWorkTrackerTasks;
@property NSTimeInterval startTimeReference;
@property NSTimeInterval downloadStartTimeReference;
@property double parseDuration;
@property double downloadDuration;
@property double totalDuration;

+ (NSString *)parserName;
+ (XMLParserType)parserType;

- (void)start;

// Subclasses must implement this method. It will be invoked on a secondary thread to keep the application responsive.
// Although NSURLConnection is inherently asynchronous, the parsing can be quite CPU intensive on the device, so
// the user interface can be kept responsive by moving that work off the main thread. This does create additional
// complexity, as any code which interacts with the UI must then do so in a thread-safe manner.
- (void)downloadAndParse:(NSURL *)url;

// Subclasses should invoke these methods and let the superclass manage communication with the delegate.
// Each of these methods must be invoked on the main thread.
- (void)downloadStarted;
- (void)downloadEnded;
- (void)parseEnded;
- (void)parsedWorkTrackerTask:(WorkTimerTask *)workTrackerTask;
- (void)parseError:(NSError *)error;
- (void)addToParseDuration:(NSNumber *)duration;

@end