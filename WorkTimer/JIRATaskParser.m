//
//  JIRATasksParser.m
//  WorkTracker
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "JIRATaskParser.h"

@implementation JIRATaskParser

+ (NSString *)parserName {
    return @"JIRATaskParser";
}

+ (XMLParserType)parserType {
    return XMLParserTypeJIRAParser;
}

@synthesize currentString, currentWorkTrackerTask, parseFormatter, xmlData, apiConnection;

- (void)downloadAndParse:(NSURL *)url {
    
    done = NO;
    self.parseFormatter = [[NSDateFormatter alloc] init];
    [parseFormatter setDateStyle:NSDateFormatterLongStyle];
    [parseFormatter setTimeStyle:NSDateFormatterNoStyle];

    // the date formatter must be set to US locale in order to parse the dates
    [parseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    self.xmlData = [NSMutableData data];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    // create the connection with the request and start loading the data
    apiConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [self performSelectorOnMainThread:@selector(downloadStarted)
                           withObject:nil
                        waitUntilDone:NO];
    if (apiConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    self.apiConnection = nil;
    self.parseFormatter = nil;
    self.currentWorkTrackerTask = nil;
}


#pragma mark NSURLConnection Delegate methods

/*
 Disable caching so that each time we run this app we are starting with a clean slate.
 You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    done = YES;
    [self performSelectorOnMainThread:@selector(parseError:)
                           withObject:error
                        waitUntilDone:NO];
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Append the downloaded chunk of data.
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self performSelectorOnMainThread:@selector(downloadEnded)
                           withObject:nil
                        waitUntilDone:NO];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    self.currentString = [NSMutableString string];
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    [parser parse];
    NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start;
    [self performSelectorOnMainThread:@selector(addToParseDuration:)
                           withObject:[NSNumber numberWithDouble:duration]
                        waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(parseEnded)
                           withObject:nil
                        waitUntilDone:NO];
    self.currentString = nil;
    self.xmlData = nil;
    // Set the condition which ends the run loop.
    done = YES;
}


#pragma mark Parsing support methods

static const NSUInteger kAutoreleasePoolPurgeFrequency = 20;

- (void)finishedTask {
    
    // performSelectorOnMainThread: will retain the object until the selector has been performed
    // setting the local reference to nil ensures that the local reference will be released
    //
    [self performSelectorOnMainThread:@selector(parsedWorkTrackerTask:)
                           withObject:currentWorkTrackerTask
                        waitUntilDone:NO];
    
    self.currentWorkTrackerTask = nil;
}


#pragma mark NSXMLParser Parsing Callbacks

// Constants for the XML element names that will be considered during the parse.
// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.
//
static NSString *kItem = @"worklog";
static NSString *kIssueID = @"issue_id";
static NSString *kIssueKey = @"issue_key";
static NSString *kIssueDescription = @"work_description";

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kItem]) {
        self.currentWorkTrackerTask = [[WorkTimerTask alloc] init];
    } else if ([elementName isEqualToString:kIssueID] || [elementName isEqualToString:kIssueKey] || [elementName isEqualToString:kIssueDescription]) {
        [currentString setString:@""];
        storingCharacters = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kItem]) {
        [self finishedTask];
    } else if ([elementName isEqualToString:kIssueID]) {
        currentWorkTrackerTask.taskID = currentString;
    } else if ([elementName isEqualToString:kIssueKey]) {
        currentWorkTrackerTask.taskKey = currentString;
    } else if ([elementName isEqualToString:kIssueDescription]) {
        currentWorkTrackerTask.taskSummary = currentString;
    }
    storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (storingCharacters) [currentString appendString:string];
}

/*
 A production application should include robust error handling as part of its parsing implementation.
 The specifics of how errors are handled depends on the application.
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
}

@end
