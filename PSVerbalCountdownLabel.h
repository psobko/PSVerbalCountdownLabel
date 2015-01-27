//
//  PSVerbalCountdownLabel.h
//  PSVerbalCountdownLabel
//
//  Created by Peter Sobkowski on 2014-10-15.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSVerbalCountdownLabel : UILabel

@property (strong, nonatomic) NSDate *targetDate;

@property (assign, nonatomic) BOOL useAbbreviations;
@property (assign, nonatomic) NSUInteger numberOfUnits;
@property (strong, nonatomic) NSString *endMessage;

@property (assign, nonatomic) BOOL isCounting;

- (void)start;
- (void)pause;
- (void)stop;

@end
