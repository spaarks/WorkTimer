//
//  Helpers.m
//  WorkTimer
//
//  Created by martin steel on 15/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

int const kSecondsInMinute = 60;
int const kMinutesInHour = 60;
int const kSecondsInHour = 3600;

+(NSString *) getDifferenceString:(NSDate*)start :(NSDate*)end
{
    NSTimeInterval distanceBetweenDates = [end timeIntervalSinceDate:start];
    NSInteger hoursBetweenDates = distanceBetweenDates / kSecondsInHour;
    
    NSInteger secondsMinusHours = distanceBetweenDates - (hoursBetweenDates * kSecondsInHour);
    NSInteger minutes = secondsMinusHours / kSecondsInMinute;
    NSInteger seconds = secondsMinusHours - minutes * kSecondsInMinute;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hoursBetweenDates, minutes, seconds];
}

+(NSString *) getTimerString:(NSDate*)current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:current];
    
    NSInteger hour= [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}

//Returns string in format "1h 30m"
+(NSString*) getJIRATimeString:(NSDate*) current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:current];
    
    NSInteger hour= [components hour];
    NSInteger minute = [components minute];
    
    return [NSString stringWithFormat:@"%02dh %02dm", hour, minute];
}

//Returns date as string in format 2014-01-16T10:30:18.932+0530
+(NSString*) getDateString:(NSDate*) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000'Z"];
    
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString*) getStartDateString
{
    NSDate * today = [NSDate date];
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setMonth:-2];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* startDate = [calendar dateByAddingComponents:dateComponents toDate:today options:0];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
 
    NSString* dateString = [dateFormatter stringFromDate:startDate];
    return dateString;
}

+(NSString*) getEndDateString
{
    NSDate * today = [NSDate date];
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setDay:1];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* endDate = [calendar dateByAddingComponents:dateComponents toDate:today options:0];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* dateString = [dateFormatter stringFromDate:endDate];
    return dateString;
}
@end
