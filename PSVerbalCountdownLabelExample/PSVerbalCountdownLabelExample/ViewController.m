//
//  ViewController.m
//  PSVerbalCountdownLabelExample
//
//  Created by Peter Sobkowski on 2014-11-04.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import "ViewController.h"
#import "PSVerbalCountdownLabel.h"

NSTimeInterval const kMinuteTimeInterval = 60;
NSTimeInterval const kHourTimeInterval = kMinuteTimeInterval * 60;
NSTimeInterval const kDayTimeInterval  = kHourTimeInterval * 24;
NSTimeInterval const kMonthTimeInterval = kDayTimeInterval * 30;
NSTimeInterval const kYearTimeInterval = kDayTimeInterval * 365;

#define datePlusTimeInterval(x) [NSDate dateWithTimeIntervalSinceNow:x]

@interface ViewController ()

@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *cLabelOne;
@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *cLabelTwo;
@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *cLabelThree;
@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *cLabelFour;
@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *cLabelFive;

@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *caLabelOne;
@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *caLabelTwo;

@property (strong, nonatomic) IBOutlet PSVerbalCountdownLabel *tLabelOne;

@property (strong, nonatomic)  NSArray *labels;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labels = @[self.cLabelTwo,
                    self.cLabelThree,
                    self.cLabelFour,
                    self.cLabelFive,
                    self.caLabelOne,
                    self.caLabelTwo,
                    self.cLabelOne,
                    self.tLabelOne];
    [self configureLabels];
    [self startTapped:nil];
}

- (void)configureLabels
{
    self.cLabelOne.targetDate = datePlusTimeInterval(5);
    self.cLabelOne.numberOfUnits = 2;
    self.cLabelOne.endMessage = @"Finished!";
    self.cLabelTwo.targetDate = datePlusTimeInterval(kMinuteTimeInterval+30);
    self.cLabelTwo.numberOfUnits = 2;
    self.cLabelThree.targetDate = datePlusTimeInterval(kHourTimeInterval*1.5);
    self.cLabelThree.numberOfUnits = 3;
    self.cLabelFour.targetDate = datePlusTimeInterval(kDayTimeInterval*1.75);
    self.cLabelFour.numberOfUnits = 4;
    self.cLabelFive.targetDate = datePlusTimeInterval(kYearTimeInterval*3.75);
    self.cLabelFive.numberOfUnits = 6;
    self.caLabelOne.targetDate = datePlusTimeInterval(kHourTimeInterval*1.15);
    self.caLabelOne.numberOfUnits = 3;
    self.caLabelOne.useAbbreviations = YES;
    self.caLabelTwo.targetDate = datePlusTimeInterval(kYearTimeInterval*1.15);
    self.caLabelTwo.numberOfUnits = 6;
    self.caLabelTwo.useAbbreviations = YES;
}

- (IBAction)startTapped:(id)sender
{
    for (PSVerbalCountdownLabel *label in self.labels)
    {
        [label start];
    }
}

- (IBAction)pauseTapped:(id)sender
{
    for (PSVerbalCountdownLabel *label in self.labels)
    {
        [label pause];
    }
}

- (IBAction)stopTapped:(id)sender
{
    for (PSVerbalCountdownLabel *label in self.labels)
    {
        [label stop];
    }
    [self configureLabels];
}

@end
