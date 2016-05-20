//
//  LZCountdownTask.h
//  LZTimerButton
//
//  Created by shanggu on 16/5/19.
//  Copyright © 2016年 shanggu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LZCountdownTask : NSOperation
/**
 *  计时中回调
 */
@property (copy, nonatomic) void (^countingDownBlcok)(NSTimeInterval timeInterval);
/**
 *  计时结束后回调
 */
@property (copy, nonatomic) void (^finishedBlcok)(NSTimeInterval timeInterval);
/**
 *  计时剩余时间
 */
@property (assign, nonatomic) NSTimeInterval leftTimeInterval;
/**
 *  后台任务标识，确保程序进入后台依然能够计时
 */
@property (assign, nonatomic) UIBackgroundTaskIdentifier taskIdentifier;
@end
