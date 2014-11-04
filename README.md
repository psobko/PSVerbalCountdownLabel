PSVerbalCountdownLabel
======================

A UILabel subclass which displays either a countdown to a specific date or a timer using words.

<img align="center" src="https://github.com/psobko/PSVerbalCountdownLabel/blob/master/PSWordyCountingLabelDemo.png" alt="Demo Image" width="320">


Properties
----------
- **targetDate**: The date to countdown to, set to nil to create a timer instead.
- **useAbbreviations**: Controls whether or not abbreviations (Yr, Mo, D, H, M, S) are used.
- **numberOfUnits**: The number of calendar units to display (Year, Month, Day, Hour, Minute, Second).
- **endMessage**: Optional text to be displayed after the countdown reaches the target date.

Usage
-----
Import `PSVerbalCountdownLabel.h` and `PSVerbalCountdownLabel.m` into your project, then `#import "PSVerbalCountdownLabel.h"` where needed.

PSVerbalCountdownLabel can be created programmatically through `[[PSVerbalCountdownLabel alloc] initWithFrame:someFrame]` or by setting a custom class on a UILabel in a xib/storyboard.

Requirements
------------
- ARC
- iOS 6.0+

Todo
----
- Make the start time property public so countdown start time can be set
- Add a target time interval to countdown in addition to a date
- Localization
- Delegation/Blocks
- Fix NSTimer issues with tests