//
//  MFGlobalCountDown.h
//  MFGlobalCountDown
//
//  Created by Tim on 2020/4/21.
//  Copyright © 2020 Tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MFGlobalCountDownIntervalMode) {
    MFGlobalCountDownIntervalMsec, /// default
    MFSGlobalCountDownIntervalSec
};

@interface MFGlobalCountDown : NSObject


/// 倒数计时器,默认 1000 毫秒间隔
/// @param time time 时长
/// @param block block 回调
/// @return MFGlobalCountDown
+ (MFGlobalCountDown *)countDownWithTime:(NSTimeInterval)time
                                   block:(void(^)(NSTimeInterval remainingTime, BOOL isComplete))block;

/// 倒数计时器
/// @param time 时长
/// @param interval 间隔
/// @param block block 回调
+ (MFGlobalCountDown *)countDownWithTime:(NSTimeInterval)time
                                interval:(NSTimeInterval)interval block:(void(^)(NSTimeInterval remainingTime, BOOL isComplete))block;


/// 倒数计时器
/// @param time 时长
/// @param interval 间隔
/// @param intervalMode 秒/毫秒
/// @param block 回调
+ (MFGlobalCountDown *)countDownWithTime:(NSTimeInterval)time
                                interval:(NSTimeInterval)interval
                           intervalMode:(MFGlobalCountDownIntervalMode)intervalMode
                                   block:(void(^)(NSTimeInterval remainingTime, BOOL isComplete))block;

/// 暂停
- (void)pause;

/// 恢复
- (void)resume;

/// 重置时长
/// @param time 时长
- (void)resetTime:(NSTimeInterval)time;

/// 重置时长
/// @param time 时长
/// @param resume 是否恢复启动
- (void)resetTime:(NSTimeInterval)time resume:(BOOL)resume;

@end

NS_ASSUME_NONNULL_END
