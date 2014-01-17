//
//  WorkTimerTests.m
//  WorkTimerTests
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "HelperTests.h"

@implementation HelperTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testGetDifferenceString
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSDate *start = [tempFormatter dateFromString:@"2014-01-01 13:00:00 000"];
    NSDate *end = [tempFormatter dateFromString:@"2014-01-01 13:30:15 000"];

    NSString *expected = @"00:30:15";
    STAssertEqualObjects(expected, [Helpers getDifferenceString:start :end], @"Difference string should be 00:30:15");
}

- (void)testGetDifferenceStringLongerThanADay
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSDate *start = [tempFormatter dateFromString:@"2014-01-01 13:00:00 000"];
    NSDate *end = [tempFormatter dateFromString:@"2014-01-02 14:30:15 000"];
    
    NSString *expected = @"25:30:15";
    STAssertEqualObjects(expected, [Helpers getDifferenceString:start :end], @"Difference string should be 25:30:15");
}

- (void)testGetTimerString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date  = [dateFormatter dateFromString:@"01:11:59"];
    
    NSString *expected = @"01:11:59";
    STAssertEqualObjects(expected, [Helpers getTimerString:date], @"Date string should be 01:11:59");
}

- (void)testGetDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *date  = [dateFormatter dateFromString:@"2014-01-05 13:30:11 000"];
    
    NSString *expected = @"2014-01-05T13:30:11.000+0000";
    STAssertEqualObjects(expected, [Helpers getDateString:date], @"Date string should be 2014-01-05T13:30:11.000Z");
    
}

- (void)testGetJIRATimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *date  = [dateFormatter dateFromString:@"2014-01-05 13:30:11 000"];
 
    NSString *expected = @"13h 30m";
    STAssertEqualObjects(expected, [Helpers getJIRATimeString:date], @"Date string should be 13h 30m");
}

//TODO - figure out how to test methods which use current date
/*
+(NSString*) getStartDateString;
+(NSString*) getEndDateString;
 */
@end
