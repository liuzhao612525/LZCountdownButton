//
//  LZButtonCountdownManager.m
//  LZTimerButton
//
//  Created by shanggu on 16/5/19.
//  Copyright © 2016年 shanggu. All rights reserved.
//

#import "LZButtonCountdownManager.h"

@interface LZButtonCountdownManager ()
@property (nonatomic, strong) NSOperationQueue *pool;
@end
@implementation LZButtonCountdownManager

+ (instancetype)defaultManager{
    static LZButtonCountdownManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LZButtonCountdownManager alloc] init];
    });
    return instance;
}
- (NSOperationQueue *)pool{
    if (!_pool) {
        _pool = [[NSOperationQueue alloc] init];
    }
    return _pool;
}
/*
LZButtonCountdownManager 拥有一个线程池（也叫并发操作队列，规定队列中最多只允许存在 20 个并发线程），每分配一个计时器（即创建一个子线程）就将其放入池子中，计时器跑完以后会自动从池子里销毁。
在创建计时任务之前，Manager 从池子里检索是否有相同 key 的计时任务，如果任务存在，直接回调计时操作。否则，新建一个标识为 key 的任务。
 */
- (void)scheduledCountDownWithKey:(NSString *)aKey
                     timeInterval:(NSTimeInterval)timeInterval
                     countingDown:(void (^)(NSTimeInterval))countingDown
                         finished:(void (^)(NSTimeInterval))finished
{
    if (timeInterval > 120) {
        NSCAssert(NO, @"受操作系统后台时间限制，倒计时时间规定不得大于 120 秒.");
    }
    if (self.pool.operations.count >= 20)  // 最多 20 个并发线程
        return;
    
    LZCountdownTask *task = nil;
    if ([self coundownTaskExistWithKey:aKey task:&task]) {
        task.countingDownBlcok = countingDown;
        task.finishedBlcok     = finished;
        if (countingDown) {
            countingDown(task.leftTimeInterval);
        }
    } else {
        task                   = [[LZCountdownTask alloc] init];
        task.name              = aKey;
        task.leftTimeInterval  = timeInterval;
        task.countingDownBlcok = countingDown;
        task.finishedBlcok     = finished;
        [self.pool addOperation:task];
    }
}


- (BOOL)coundownTaskExistWithKey:(NSString *)akey
                            task:(NSOperation *__autoreleasing  _Nullable *)task
{
    __block BOOL taskExist = NO;
    [self.pool.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:akey]) {
            if (task) *task = obj;
            taskExist = YES;
            *stop     = YES;
        }
    }];
    
    return taskExist;
}
@end

