//
//  WorkTimerTests.m
//  WorkTimerTests
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "WorkTimerTests.h"

@implementation WorkTimerTests

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

- (void)testGetTimeDifference
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSDate *start = [tempFormatter dateFromString:@"2014-01-01 13:00:00 000"];
    NSDate *end = [tempFormatter dateFromString:@"2014-01-01 13:30:15 000"];

    NSString *expected = @"00:30:15";
    STAssertEqualObjects(expected, [Helpers getDifferenceString:start :end], @"Difference string should be 00:30:15");
}

- (void)testGetTimeDifferenceLongerThanADay
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
@end
