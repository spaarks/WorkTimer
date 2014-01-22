//
//  ProtocolTaskParserDelegate.h
//  WorkTimer
//
//  Created by martin steel on 22/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskParser;

@protocol ProtocolTaskParserDelegate <NSObject>

@optional

- (void)parserDidEndParsingData:(TaskParser *)parser;
- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error;
// Called by the parser when one or more items have been parsed.
// This method may be called multiple times.
- (void)parser:(TaskParser *)parser didParseWorkTimerTasks:(NSArray *)parsedWorkTimerTasks;

@end