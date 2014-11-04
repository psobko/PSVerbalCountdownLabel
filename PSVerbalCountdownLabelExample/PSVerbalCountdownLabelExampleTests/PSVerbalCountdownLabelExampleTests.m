//
//  PSVerbalCountdownLabelExampleTests.m
//  PSVerbalCountdownLabelExampleTests
//
//  Created by Peter Sobkowski on 2014-11-04.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PSVerbalCountdownLabel.h"

NSTimeInterval const k30SecondTimeInterval = 30;
NSTimeInterval const kMinuteTimeInterval = 60;
NSTimeInterval const kHourTimeInterval = kMinuteTimeInterval * 60;
NSTimeInterval const kDayTimeInterval  = kHourTimeInterval * 24;
NSTimeInterval const kMonthTimeInterval = kDayTimeInterval * 30;
NSTimeInterval const kYearTimeInterval = kDayTimeInterval * 365;

#define XCTAssertEqualStrings(string1, string2) XCTAssertTrue([string1 isEqualToString:string2], @"\"%@\" should be \"%@\"", string1, string2)


@interface PSVerbalCountdownLabelExampleTests : XCTestCase
{
    PSVerbalCountdownLabel *testLabel;
}

@end

@implementation PSVerbalCountdownLabelExampleTests

#pragma mark - Setup/Teardown

- (void)setUp
{
    [super setUp];
    UIViewController *testViewController = [[UIViewController alloc] init];

    XCTAssert(testViewController.view,
              @"View controller should be instantiated correctly");
    
    testLabel = [[PSVerbalCountdownLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [testViewController.view addSubview:testLabel];
    
    XCTAssert(testLabel.superview == testViewController.view,
              @"Label should be a subview of the test view controller");
}

- (void)tearDown
{
    testLabel = nil;
    [super tearDown];
}

#pragma mark - Tests

#pragma mark - Init

- (void)testLabelCanInstantiate
{
    XCTAssert(testLabel, @"Should instantiate");
}

- (void)testLabelTextInitializesAsNil
{
    XCTAssertNil(testLabel.text);
}

- (void)testAbbreviationsAreOffByDefault
{
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kMinuteTimeInterval];
    XCTAssertEqualStrings(testLabel.text, @"59 Seconds");
}

- (void)testAllDateUnitsAreDisplayedByDefault
{
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months 0 Days 0 Hours 0 Minutes 0 Seconds");
}

-(void)testEndMessageIsNilByDefault
{
    testLabel.targetDate = [NSDate date];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
}

#pragma mark - Setters

- (void)testSettingDatePopulatesLabel
{
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kMinuteTimeInterval];
    [self waitForCompletion:1.1];
    XCTAssertEqualStrings(testLabel.text, @"59 Seconds");
}

- (void)testSettingNilDateDoesNotPopulateLabel
{
    testLabel.targetDate = nil;
    XCTAssertNil(testLabel.text, @"Label text should be nil");
}

#pragma mark - Countdown
//TODO: increase time interval for countdown tests
- (void)testCountdownStarts
{
    testLabel.numberOfUnits = 2;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kMinuteTimeInterval];
    XCTAssertEqualStrings(testLabel.text, @"59 Seconds");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"57 Seconds");
}

- (void)testCountdownPauses
{
    testLabel.numberOfUnits = 2;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kMinuteTimeInterval];
    XCTAssertEqualStrings(testLabel.text, @"59 Seconds");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
    [testLabel pause];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
}

- (void)testCountdownResumes
{
    testLabel.numberOfUnits = 2;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kMinuteTimeInterval];
    XCTAssertEqualStrings(testLabel.text, @"59 Seconds");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
    [testLabel pause];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"57 Seconds");
}

- (void)testCountdownStops
{
    testLabel.numberOfUnits = 1;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kMinuteTimeInterval];
    XCTAssertEqualStrings(testLabel.text, @"59 Seconds");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
    [testLabel stop];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"58 Seconds");
}


#pragma mark - Countdown End Message

-(void)testEndMessageDisplaysWhenCountdownFinishes
{
    testLabel.endMessage = @"Finished";
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:2];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [testLabel start];
    [self waitForCompletion:2];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:2];
    XCTAssertEqualStrings(testLabel.text, @"Finished");
    [self waitForCompletion:2];
    XCTAssertEqualStrings(testLabel.text, @"Finished");
}

-(void)testEndMessageDisplaysWhenCountdownStoppedManually
{
    testLabel.endMessage = @"Finished";
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:2];

    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [testLabel start];
    [self waitForCompletion:2];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [testLabel stop];
    XCTAssertEqualStrings(testLabel.text, @"Finished");
    [self waitForCompletion:2];
    XCTAssertEqualStrings(testLabel.text, @"Finished");
}

#pragma mark - Timer

- (void)testTimerStarts
{
    testLabel.targetDate = nil;
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"2 Seconds");
}

- (void)testTimerPauses
{
    testLabel.targetDate = nil;
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [testLabel pause];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
}

- (void)testTimerResumes
{
    testLabel.targetDate = nil;
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [testLabel pause];
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"2 Seconds");
}

- (void)testTimerStops
{
    testLabel.targetDate = nil;
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [testLabel stop];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
}

-(void)testTimerResetsAfterStopping
{
    testLabel.targetDate = nil;
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");
    [testLabel stop];
    [testLabel start];
    XCTAssertEqualStrings(testLabel.text, @"0 Seconds");
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"1 Second");

}



#pragma mark - Abbreviations

- (void)testAbbreviationsNotUsedIfDisabled
{
    testLabel.useAbbreviations = NO;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months 0 Days 0 Hours 0 Minutes 0 Seconds");
}

- (void)testAbbreviationSetterUpdatesText
{
    
}

- (void)testPluralizationIfAbbreviationsNotUsed
{
    //TODO: check if leap years/# days in month could break this
    testLabel.useAbbreviations = NO;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:(kYearTimeInterval*3)];
    XCTAssertEqualStrings(testLabel.text, @"2 Years 11 Months 30 Days 0 Hours 59 Minutes 59 Seconds");
    
    //TODO: adjust for # days in month
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+(kDayTimeInterval*30)+kDayTimeInterval+kHourTimeInterval+kMinuteTimeInterval+2];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 1 Month 1 Day 1 Hour 1 Minute 1 Second");
}

- (void)testAbbreviationsUsedIfEnabled
{
    testLabel.useAbbreviations = YES;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Yr 0 M 0 D 0 Hrs 0 Mins 0 Secs");
}

- (void)testPluralizationIfAbbreviationsUsed
{
    //TODO: check if leap years/# days in month could break this
    testLabel.useAbbreviations = YES;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:(kYearTimeInterval*3)];
    XCTAssertEqualStrings(testLabel.text, @"2 Yrs 11 M 30 D 0 Hrs 59 Mins 59 Secs");
    
    //TODO: adjust for # days in month
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+(kDayTimeInterval*30)+kDayTimeInterval+kHourTimeInterval+kMinuteTimeInterval+2];
    XCTAssertEqualStrings(testLabel.text, @"1 Yr 1 M 1 D 1 Hr 1 Min 1 Sec");
}

#pragma mark - Calendar units

-(void)testCorrectAmountOfCalendarUnitsDisplayed
{
    testLabel.numberOfUnits = 1;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year");

    testLabel.numberOfUnits = 2;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months");

    testLabel.numberOfUnits = 3;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months 0 Days");
    
    testLabel.numberOfUnits = 4;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months 0 Days 0 Hours");
    
    testLabel.numberOfUnits = 5;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months 0 Days 0 Hours 0 Minutes");
    
    testLabel.numberOfUnits = 6;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:kYearTimeInterval+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Year 0 Months 0 Days 0 Hours 0 Minutes 0 Seconds");
}

-(void)testCalendarUnitsUpdateForTimer
{
    //TODO: add tests for timer
}

-(void)testCalendarUnitsUpdateForCountdown
{
    testLabel.numberOfUnits = 2;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:(kMinuteTimeInterval*60)+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Hour 0 Minutes");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"59 Minutes 59 Seconds");
    
    [testLabel stop];
    
    testLabel.numberOfUnits = 3;
    testLabel.targetDate = [NSDate dateWithTimeIntervalSinceNow:(kMinuteTimeInterval*60)+1];
    XCTAssertEqualStrings(testLabel.text, @"1 Hour 0 Minutes 0 Seconds");
    [testLabel start];
    [self waitForCompletion:1];
    XCTAssertEqualStrings(testLabel.text, @"59 Minutes 59 Seconds");
    
    //???: add mode to keep 0 values displayed?
}


#pragma mark - Helper Methods
#pragma mark

- (void)waitForCompletion:(NSTimeInterval)timeoutSecs
{
    BOOL done = NO;
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        done = ([timeoutDate timeIntervalSinceNow] < 0.0);
    } while (!done);
}


@end
