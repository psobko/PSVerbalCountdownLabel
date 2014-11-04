//
//  PSVerbalCountdownLabel.m
//  PSVerbalCountdownLabel
//
//  Created by Peter Sobkowski on 2014-10-15.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import "PSVerbalCountdownLabel.h"

NSTimeInterval const updateTimerFrequency = 1.0f;

@interface PSVerbalCountdownLabel()

@property (strong, nonatomic) NSTimer *updateTimer;
@property (strong, nonatomic) NSDate *pausedDate;
@property (strong, nonatomic) NSDate *startDate;

@end

@implementation PSVerbalCountdownLabel

#pragma mark - Initialization

-(void)commonInit
{
    _numberOfUnits = 6;
}

- (id)init
{
    if (self = [super init])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
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

#pragma mark - Setters

- (void)setTargetDate:(NSDate *)targetDate
{
    _targetDate = targetDate;
    if(targetDate)
    {
        [self updateLabel];
    }
}

- (void)setUseAbbreviations:(BOOL)useAbbreviations
{
    _useAbbreviations = useAbbreviations;
    
    if(self.targetDate)
    {
        [self updateLabel];
    }
}

#pragma mark - Public

- (void)start
{
    [self setupTimer];
    
    if(!self.startDate)
    {
        self.startDate = [NSDate date];
    }
    
    if(self.pausedDate)
    {
        self.startDate = [NSDate dateWithTimeIntervalSinceNow:[self.startDate timeIntervalSinceDate:self.pausedDate]];
        self.pausedDate = nil;
    }
    [self.updateTimer fire];
    self.isCounting = YES;
}

- (void)stop
{
    [self stopTimer];

    if(!self.targetDate)
    {
        self.startDate = nil;
    }
    if(self.endMessage)
    {
        self.text = self.endMessage;
    }
}

- (void)pause
{
    if(self.isCounting)
    {
        self.pausedDate = [NSDate date];
        [self stopTimer];
    }
}

#pragma mark - Private

-(void)setupTimer
{
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }

    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateTimerFrequency
                                                        target:self
                                                      selector:@selector(updateLabel)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)stopTimer
{
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        self.isCounting = NO;
    }

}

-(void)updateLabel
{
    NSDate *startingDate = (self.targetDate) ? [NSDate date] : self.startDate;
    NSDate *endDate = (self.targetDate) ?: [self.startDate dateByAddingTimeInterval:[[NSDate date] timeIntervalSinceDate:self.startDate]];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    enum NSCalendarUnit unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;

    NSDateComponents *dateComponents = [calendar components:unitFlags
                                                   fromDate:startingDate
                                                     toDate:endDate
                                                    options:0];
    if([dateComponents second] < 0)
    {
        [self stopTimer];
        [dateComponents setSecond:0];
        if(self.endMessage)
        {
            self.text = self.endMessage;
            return;
        }
    }
    NSCalendarUnit maxCalendarunit = [self maximumCalendarUnitForDateComponents:dateComponents];
    self.text = [self stringForDateComponents:dateComponents
                             withCalendarUnit:maxCalendarunit
                             andNumberOfUnits:self.numberOfUnits];
}

-(NSString *)stringForDateComponents:(NSDateComponents*)dateComponents withCalendarUnit:(NSCalendarUnit)calendarUnit andNumberOfUnits:(NSInteger)numberOfUnits
{
    NSMutableString *dateString = [@"" mutableCopy];
    NSInteger componentCount = 0;
    
    switch (calendarUnit)
    {
        case NSCalendarUnitYear:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents year], [self stringForCalendarUnit:NSCalendarUnitYear
                                                                                                withValue:[dateComponents year]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitMonth:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents month], [self stringForCalendarUnit:NSCalendarUnitMonth
                                                                                                 withValue:[dateComponents month]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitDay:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents day], [self stringForCalendarUnit:NSCalendarUnitDay
                                                                                               withValue:[dateComponents day]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitHour:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents hour], [self stringForCalendarUnit:NSCalendarUnitHour
                                                                                                withValue:[dateComponents hour]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitMinute:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents minute], [self stringForCalendarUnit:NSCalendarUnitMinute
                                                                                                  withValue:[dateComponents minute]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        case NSCalendarUnitSecond:
            [dateString appendFormat:@"%ld %@ ", (long)[dateComponents second], [self stringForCalendarUnit:NSCalendarUnitSecond
                                                                                                  withValue:[dateComponents second]]];
            componentCount++;
            if(componentCount == numberOfUnits)
                break;
            
        default:
            break;
    }
    
    return [dateString substringToIndex:dateString.length -1];
}


- (NSString *)stringForCalendarUnit:(NSCalendarUnit)calendarUnit withValue:(NSInteger)value
{
    BOOL singular = (value == 1);
    
    if(self.useAbbreviations)
    {
        switch (calendarUnit) {
            case NSCalendarUnitYear:    return singular ? @"Yr" : @"Yrs";
            case NSCalendarUnitMonth:   return singular ? @"M" : @"M";
//            case NSCalendarUnitWeekOfMonth: return singular ? @"Wk" : @"Wks";
            case NSCalendarUnitDay:     return singular ? @"D" : @"D";
            case NSCalendarUnitHour:    return singular ? @"Hr" : @"Hrs";
            case NSCalendarUnitMinute:  return singular ? @"Min" : @"Mins";
            case NSCalendarUnitSecond:  return singular ? @"Sec" : @"Secs";
            default: break;
        }
    }
    else
    {
        switch (calendarUnit) {
            case NSCalendarUnitYear:    return singular ? @"Year" : @"Years";
            case NSCalendarUnitMonth:   return singular ? @"Month" : @"Months";
//            case NSCalendarUnitWeekOfMonth: return singular ? @"Week" : @"Weeks";
            case NSCalendarUnitDay:     return singular ? @"Day" : @"Days";
            case NSCalendarUnitHour:    return singular ? @"Hour" : @"Hours";
            case NSCalendarUnitMinute:  return singular ? @"Minute" : @"Minutes";
            case NSCalendarUnitSecond:  return singular ? @"Second" : @"Seconds";
            default: break;
        }
    }
    return nil;
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
