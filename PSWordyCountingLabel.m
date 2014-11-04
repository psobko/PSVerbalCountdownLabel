//
//  PSWordyCountingLabel.m
//  PSWordyCountingLabel
//
//  Created by Peter Sobkowski on 2014-10-15.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import "PSWordyCountingLabel.h"

@interface PSWordyCountingLabel()

@property (strong, nonatomic) NSTimer *updateTimer;

@end

@implementation PSWordyCountingLabel

-(void)commonInit
{
    _useAbbreviation = YES;
    _maximumNumberOfUnits = 2;
}

- (id)init
{
    if (self = [super init])
    {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib
{
    [self commonInit];
}

-(void)dealloc
{
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
    }
}

#pragma mark - Public

- (void)start
{
    [self setupTimer];
}

- (void)stop
{
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
    }}

#pragma mark - Private

-(void)setupTimer
{
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
    }
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(updateLabel)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.updateTimer fire];
}

-(void)updateLabel
{
    NSDate *startingDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;

    NSDateComponents *dateComponents = [calendar components:unitFlags
                                                   fromDate:startingDate
                                                     toDate:self.targetDate
                                                    options:0];
    if([dateComponents second] < 0)
    {
        self.text = self.endMessage;
        [self stop];
        return;
    }
    NSCalendarUnit maxCalendarunit = [self maximumCalendarUnitForDateComponents:dateComponents];
    self.text = [@"Spin available in " stringByAppendingString:[self stringForDateComponents:dateComponents
                                                                      withCalendarUnit:maxCalendarunit
                                                                      andNumberOfUnits:self.maximumNumberOfUnits]];
}


-(NSString *)stringForDateComponents:(NSDateComponents*)dateComponents withCalendarUnit:(NSCalendarUnit)calendarUnit andNumberOfUnits:(NSInteger)numberOfUnits
{
    NSMutableString *dateString = [@"" mutableCopy];
    NSInteger componentCount = 0;
    
    switch (calendarUnit)
    {
        case NSCalendarUnitYear:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents year], [self descriptionStringForCalendarUnit:NSCalendarUnitYear
                                                                                                           withValue:[dateComponents year]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitMonth:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents month], [self descriptionStringForCalendarUnit:NSCalendarUnitMonth
                                                                                                            withValue:[dateComponents month]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitDay:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents day], [self descriptionStringForCalendarUnit:NSCalendarUnitDay
                                                                                                          withValue:[dateComponents day]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitHour:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents hour], [self descriptionStringForCalendarUnit:NSCalendarUnitHour
                                                                                                           withValue:[dateComponents hour]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitMinute:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents minute], [self descriptionStringForCalendarUnit:NSCalendarUnitMinute
                                                                                                             withValue:[dateComponents minute]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitSecond:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents second], [self descriptionStringForCalendarUnit:NSCalendarUnitSecond
                                                                                                             withValue:[dateComponents second]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        default:
            break;
    }
    
    return [NSString stringWithString:dateString];
}


- (NSString *)descriptionStringForCalendarUnit:(NSCalendarUnit)calendarUnit withValue:(NSInteger)value
{
    BOOL singular = (value == 1);
    
    if(self.useAbbreviation)
    {
        switch (calendarUnit) {
            case NSCalendarUnitYear:
                return singular ? @"Yr" : @"Yrs";
            case NSCalendarUnitMonth:
                return singular ? @"M" : @"M";
                //            case NSCalendarUnitWeekOfMonth:
                //                return singular ? @"Wk" : @"Wks";
            case NSCalendarUnitDay:
                return singular ? @"D" : @"D";
            case NSCalendarUnitHour:
                return singular ? @"Hr" : @"Hrs";
            case NSCalendarUnitMinute:
                return singular ? @"Min" : @"Mins";
            case NSCalendarUnitSecond:
                return singular ? @"Sec" : @"Secs";
            default:
                return nil;
        }
    }
    else
    {
        switch (calendarUnit) {
            case NSCalendarUnitYear:
                return singular ? @"Year" : @"Years";
            case NSCalendarUnitMonth:
                return singular ? @"Month" : @"Months";
                //            case NSCalendarUnitWeekOfMonth:
                //                return singular ? @"Week" : @"Weeks";
            case NSCalendarUnitDay:
                return singular ? @"Day" : @"Days";
            case NSCalendarUnitHour:
                return singular ? @"Hour" : @"Hours";
            case NSCalendarUnitMinute:
                return singular ? @"Minute" : @"Minuts";
            case NSCalendarUnitSecond:
                return singular ? @"Second" : @"Seconds";
            default:
                return nil;
        }
        
   
    }
}

- (NSCalendarUnit)maximumCalendarUnitForDateComponents:(NSDateComponents*)dateComponents
{
    if([dateComponents year] != 0)
        return NSCalendarUnitYear;
    if([dateComponents month] != 0)
        return NSCalendarUnitMonth;
    if([dateComponents day] != 0)
        return NSCalendarUnitDay;
    if([dateComponents hour] != 0)
        return NSCalendarUnitHour;
    if([dateComponents minute] != 0)
        return NSCalendarUnitMinute;
    return NSCalendarUnitSecond;
}

@end
