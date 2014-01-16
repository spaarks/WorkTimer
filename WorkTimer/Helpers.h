//
//  Helpers.h
//  WorkTimer
//
//  Created by martin steel on 15/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject
+(NSString *)   getDifferenceString:(NSDate*)start :(NSDate*)end;
+(NSString *) getTimerString:(NSDate*)current;
+(NSString *) getDateString:(NSDate*) date;
+(NSString*) getJIRATimeString:(NSDate*) current;
+(NSString*) getStartDateString;
+(NSString*) getEndDateString;
@end
