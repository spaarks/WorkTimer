//
//  WorkTimerTests.m
//  WorkTimerTests
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Helpers.h"
#import "WorkTimerTask.h"

@interface HelperTests : XCTestCase
@end

@implementation HelperTests

-(void)testGetTimeFromString
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"HH:mm:ss"];
    NSDate *expected = [tempFormatter dateFromString:@"00:30:15"];
    
    NSDate* actual = [Helpers getTimeFromString:@"00:30:15"];
    
    XCTAssertEqualObjects(expected, actual, @"Time should be 00:30:15");
}

- (void)testGetDifferenceString
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSDate *start = [tempFormatter dateFromString:@"2014-01-01 13:00:00 000"];
    NSDate *end = [tempFormatter dateFromString:@"2014-01-01 13:30:15 000"];

    NSString *expected = @"00:30:15";
    XCTAssertEqualObjects(expected, [Helpers getDifferenceString:start :end], @"Difference string should be 00:30:15");
}

- (void)testGetDifferenceStringLongerThanADay
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSDate *start = [tempFormatter dateFromString:@"2014-01-01 13:00:00 000"];
    NSDate *end = [tempFormatter dateFromString:@"2014-01-02 14:30:15 000"];
    
    NSString *expected = @"25:30:15";
    XCTAssertEqualObjects(expected, [Helpers getDifferenceString:start :end], @"Difference string should be 25:30:15");
}

- (void)testGetTimerString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date  = [dateFormatter dateFromString:@"01:11:59"];
    
    NSString *expected = @"01:11:59";
    XCTAssertEqualObjects(expected, [Helpers getTimerString:date], @"Date string should be 01:11:59");
}

-(void) testGetHours
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date  = [dateFormatter dateFromString:@"09:11:59"];
    
    XCTAssertEqual(9, [Helpers getHours:date], @"Hours should be 9");
}

-(void) testGetMinutes
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date  = [dateFormatter dateFromString:@"09:11:59"];
    
    XCTAssertEqual(11, [Helpers getMinutes:date], @"Minutes should be 11");
}

-(void) testGetSeconds
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date  = [dateFormatter dateFromString:@"09:11:59"];
    
    XCTAssertEqual(59, [Helpers getSeconds:date], @"Seconds should be 59");
}

- (void)testGetDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *date  = [dateFormatter dateFromString:@"2014-01-05 13:30:11 000"];
    
    NSString *expected = @"2014-01-05T13:30:11.000+0000";
    XCTAssertEqualObjects(expected, [Helpers getDateString:date], @"Date string should be 2014-01-05T13:30:11.000Z");
    
}

- (void)testGetJIRATimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *date  = [dateFormatter dateFromString:@"2014-01-05 13:30:11 000"];
 
    NSString *expected = @"13h 30m";
    XCTAssertEqualObjects(expected, [Helpers getJIRATimeString:date], @"Date string should be 13h 30m");
}

- (void)testGetDateFromComponents
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *expected  = [dateFormatter dateFromString:@"2000-01-01 13:30:15 000"];
    
    NSDate* actual = [Helpers getDateFromComponents:13 :30 :15];
    
    XCTAssertEqualObjects(expected, actual, @"Date should be 13h 30m 15s");
}

//TODO - figure out how to test methods which use current date
/*
+(NSString*) getStartDateString;
+(NSString*) getEndDateString;
 */

-(void)testEncodeString
{
    NSString *data = @"martin.steel@spaarks.com:Yellow12";
    NSString *expected = @"bWFydGluLnN0ZWVsQHNwYWFya3MuY29tOlllbGxvdzEy";
    XCTAssertEqualObjects(expected, [Helpers encodeString:data],
                         @"Encoded string should be bWFydGluLnN0ZWVsQHNwYWFya3MuY29tOlllbGxvdzEy");
}

-(void)testRoundDateMinutesOnly
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *initial  = [dateFormatter dateFromString:@"2000-01-01 00:28:00 000"];
    NSDate *expected  = [dateFormatter dateFromString:@"2000-01-01 00:30:00 000"];
    
    XCTAssertEqualObjects(expected, [Helpers roundDate:initial], @"Date should be 00h 30m 0s");
}

-(void)testRoundDateGreaterThanAnHour
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    NSDate *initial  = [dateFormatter dateFromString:@"2000-01-01 01:28:00 000"];
    NSDate *expected  = [dateFormatter dateFromString:@"2000-01-01 01:30:00 000"];
    
    XCTAssertEqualObjects(expected, [Helpers roundDate:initial], @"Date should be 01h 30m 0s");
}

-(void)testSortArrayAlphabetically
{
    WorkTimerTask* one = [[WorkTimerTask alloc] init];
    one.taskKey =@"Second 0";
    WorkTimerTask* two = [[WorkTimerTask alloc] init];
    two.taskKey = @"First 1";
    WorkTimerTask* three = [[WorkTimerTask alloc] init];
    three.taskKey = @"First 2";
    WorkTimerTask* four = [[WorkTimerTask alloc] init];
    four.taskKey = @"First 10";

    NSArray *arr =  [[NSArray alloc] initWithObjects:one,two,three,four, nil];
    NSArray *expected = [[NSArray alloc] initWithObjects:two,three,four,one,nil];
    
    XCTAssertEqualObjects(expected, [Helpers sortArrayAlphabetically:arr :@"taskKey"], @"Arrays should be in the same order");
}

@end
