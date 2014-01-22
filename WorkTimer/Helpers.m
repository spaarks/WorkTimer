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
static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSString *)encodeString:(NSString *)data
{
    const char *input = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long inputLength = [data length];
    unsigned long modulo = inputLength % 3;
    unsigned long outputLength = (inputLength / 3) * 4 + (modulo ? 4 : 0);
    unsigned long j = 0;
    
    // Do not forget about trailing zero
    unsigned char *output = malloc(outputLength + 1);
    output[outputLength] = 0;
    
    // Here are no checks inside the loop, so it works much faster than other implementations
    for (unsigned long i = 0; i < inputLength; i += 3) {
        output[j++] = alphabet[ (input[i] & 0xFC) >> 2 ];
        output[j++] = alphabet[ ((input[i] & 0x03) << 4) | ((input[i + 1] & 0xF0) >> 4) ];
        output[j++] = alphabet[ ((input[i + 1] & 0x0F)) << 2 | ((input[i + 2] & 0xC0) >> 6) ];
        output[j++] = alphabet[ (input[i + 2] & 0x3F) ];
    }
    // Padding in the end of encoded string directly depends of modulo
    if (modulo > 0) {
        output[outputLength - 1] = '=';
        if (modulo == 1)
            output[outputLength - 2] = '=';
    }
    NSString *s = [NSString stringWithUTF8String:(const char *)output];
    free(output);
    return s;
}
@end
