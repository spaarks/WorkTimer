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

+(NSDate *) getTimeFromString:(NSString*)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    return [dateFormatter dateFromString:timeString];
}

+(NSString *) getDifferenceString:(NSDate*)start :(NSDate*)end
{
    NSTimeInterval distanceBetweenDates = [end timeIntervalSinceDate:start];
    int hoursBetweenDates = ((int)(distanceBetweenDates / kSecondsInHour));
    
    int secondsMinusHours = ((int)(distanceBetweenDates - (hoursBetweenDates * kSecondsInHour)));
    int minutes = ((int)(secondsMinusHours / kSecondsInMinute));
    int seconds = ((int)(secondsMinusHours - minutes * kSecondsInMinute));
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hoursBetweenDates, minutes, seconds];
}

+(NSString *) getTimerString:(NSDate*)current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:current];
    
    int hour= (int)[components hour];
    int minute = (int)[components minute];
    int second = (int)[components second];
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}

+(int) getHours:(NSDate*)current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:current];
    
    return (int)[components hour];
}

+(int) getMinutes:(NSDate*)current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:current];
    
    return (int)[components minute];
}

+(int) getSeconds:(NSDate*)current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:current];
    
    return (int)[components second];
}

//Returns string in format "1h 30m"
+(NSString*) getJIRATimeString:(NSDate*) current
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:current];
    
    int hour= (int)[components hour];
    int minute = (int)[components minute];
    
    return [NSString stringWithFormat:@"%02dh %02dm", hour, minute];
}

+(NSDate*) getDateFromComponents:(int)hours
                                :(int)minutes
                                :(int)seconds
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"HH:mm:ss"];
    
    NSString *dateAsString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    return [tempFormatter dateFromString:dateAsString];
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

+(NSDate*)roundDate:(NSDate*)unrounded
{
    int hours = [Helpers getHours:unrounded];
    int minutes = [Helpers getMinutes:unrounded];
    
    int remainder = minutes % 15;
    int baseMinutes = minutes - remainder;
    
    if(baseMinutes==0)
        minutes = 15;
    else if(remainder>7)
        minutes = baseMinutes + 15;
    else minutes = baseMinutes;
    
    int seconds = 0;
    
    return [Helpers getDateFromComponents:hours:minutes:seconds];
}

+(NSArray*)sortArrayAlphabetically:(NSArray*)unsorted
                                 :(NSString*)descriptorKey
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:descriptorKey ascending:YES comparator:^(NSString *obj1, NSString *obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch | NSCaseInsensitiveSearch];
        
    }];
    
    return [unsorted sortedArrayUsingDescriptors:@[descriptor]];
}
@end
