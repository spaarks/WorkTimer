//
//  ParseTasks.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkTimerTask.h"
#import "JIRAProjectRepository.h"
#import "ProtocolTaskParserDelegate.h"

typedef enum {
    XMLParserTypeAbstract = -1,
    XMLParserTypeJIRAParser = 0,
    XMLParserTypeHarvestParser = 1
} XMLParserType;



#pragma mark -

@interface TaskParser : NSObject 

@property (nonatomic, weak) id <ProtocolTaskParserDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *parsedWorkTimerTasks;

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
- (void)parsedWorkTimerTask:(WorkTimerTask *)WorkTimerTask;
- (void)parseError:(NSError *)error;

@end