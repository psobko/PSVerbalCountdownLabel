//
//  PSWordyCountingLabel.h
//  PSWordyCountingLabel
//
//  Created by Peter Sobkowski on 2014-10-15.
//  Copyright (c) 2014 psobko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSWordyCountingLabel : UILabel

@property (assign, nonatomic) BOOL useAbbreviation;
@property (assign, nonatomic) int maximumNumberOfUnits;
@property (strong, nonatomic) NSDate *targetDate;
@property (strong, nonatomic) NSString *endMessage;

//TODO: countdown/up

- (void)start;
- (void)stop;

@end
