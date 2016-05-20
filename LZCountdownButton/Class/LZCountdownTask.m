//
//  LZCountdownTask.m
//  LZTimerButton
//
//  Created by shanggu on 16/5/19.
//  Copyright © 2016年 shanggu. All rights reserved.
//

#import "LZCountdownTask.h"

@implementation LZCountdownTask
- (void)main {
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    while (--_leftTimeInterval > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_countingDownBlcok) _countingDownBlcok(_leftTimeInterval);
        });
        
        [NSThread sleepForTimeInterval:1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_finishedBlcok) {
            _finishedBlcok(0);
        }
    });
    
    if (self.taskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}
@end
