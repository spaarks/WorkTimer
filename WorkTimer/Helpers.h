//
//  Helpers.h
//  WorkTimer
//
//  Created by martin steel on 15/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject
+(NSDate *) getTimeFromString:(NSString*)timeString;
+(NSString *)   getDifferenceString:(NSDate*)start :(NSDate*)end;
+(NSString *) getTimerString:(NSDate*)current;
+(int) getHours:(NSDate*)current;
+(int) getMinutes:(NSDate*)current;
+(int) getSeconds:(NSDate*)current;
+(NSString *) getDateString:(NSDate*) date;
+(NSString*) getJIRATimeString:(NSDate*) current;
+(NSDate*) getDateFromComponents:(int)hours
                                :(int)minutes
                                :(int)seconds;
+(NSString*) getStartDateString;
+(NSString*) getEndDateString;
+(NSString *)encodeString:(NSString *)data;
@end
