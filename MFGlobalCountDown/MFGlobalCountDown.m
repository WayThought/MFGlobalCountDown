//
//  MFGlobalCountDown.m
//  MFGlobalCountDown
//
//  Created by Tim on 2020/4/21.
//  Copyright © 2020 Tim. All rights reserved.
//

#import "MFGlobalCountDown.h"

@interface MFGlobalCountDown ()
/// 初始时间
@property (nonatomic, assign, readwrite) NSTimeInterval totalTime;

/// 间隔时间
@property (nonatomic, assign, readwrite) NSTimeInterval interval;

/// 毫秒或者秒mode
@property (nonatomic, assign, readwrite) MFGlobalCountDownIntervalMode intervalMode;

/// 剩余时间
@property (nonatomic, assign, readwrite) NSTimeInterval remainingTime;

/// block回调
@property (nonatomic, copy) void (^block)(NSTimeInterval remainingTime, BOOL complete);

/// 进入后台的时间
@property (nonatomic, assign) NSTimeInterval timestampWithEnterBackground;

@property (nonatomic, strong) id backgroundObserver;
@property (nonatomic, strong) id activeObserver;

@end

@implementation MFGlobalCountDown {
    // source
    dispatch_source_t _timer;
    BOOL _enterBackground;
    BOOL _paused;
    BOOL _resumed;
    BOOL _resumedBeforeEnterBackground;
}


/// 倒数计时器,默认 1000 毫秒间隔
/// @param time time 时长
/// @param block block 回调
/// @return MFGlobalCountDown
+ (MFGlobalCountDown *)countDownWithTime:(NSTimeInterval)time
                                   block:(void(^)(NSTimeInterval remainingTime, BOOL isComplete))block {
    return [self countDownWithTime:time
                          interval:1000
                             block:block];
}

/// 倒数计时器
/// @param time 时长
/// @param interval 间隔
/// @param block block 回调
+ (MFGlobalCountDown *)countDownWithTime:(NSTimeInterval)time
                                interval:(NSTimeInterval)interval block:(void(^)(NSTimeInterval remainingTime, BOOL isComplete))block {
    return [self countDownWithTime:time interval:interval intervalMode:MFGlobalCountDownIntervalMsec block:block];
}


/// 倒数计时器
/// @param time 时长
/// @param interval 间隔
/// @param intervalMode 秒/毫秒
/// @param block 回调
+ (MFGlobalCountDown *)countDownWithTime:(NSTimeInterval)time
                                interval:(NSTimeInterval)interval
                           intervalMode:(MFGlobalCountDownIntervalMode)intervalMode block:(void(^)(NSTimeInterval remainingTime, BOOL isComplete))block {
    MFGlobalCountDown *timer = [[MFGlobalCountDown alloc] init];
    timer.totalTime = time;
    timer.block = block;
    timer.interval = interval;
    timer.intervalMode = intervalMode;
    timer.remainingTime = time;
    // 实例化定时器
    [timer initTimer];
    [timer resumeIfNecessary];
    return timer;
}

- (void)initTimer {
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), _interval * (_intervalMode == MFSGlobalCountDownIntervalSec ? NSEC_PER_SEC : NSEC_PER_MSEC) , 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.remainingTime <= 0) {
                [strongSelf countDownCompletion];
            }
            else {
                strongSelf.remainingTime -= strongSelf.interval;
                if (strongSelf.remainingTime <= 0) {
                    [strongSelf countDownCompletion];
                }
                else {
                    [strongSelf countDownAction];
                }
            }
        });
    });
    
    dispatch_source_set_cancel_handler(_timer, ^{
        
    });
    
    // 进入后台的监听
    self.backgroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf applicationDidEnterBackground];
    }];
    // 回到前台的监听
    self.activeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf applicationDidBecomeActive];
    }];
}

- (void)invalidateTimer {
    
}

- (void)dealloc {
    if (_timer && !dispatch_source_testcancel(_timer)) {
        if (_paused) {
            dispatch_resume(_timer);
            _paused = NO;
        }
        dispatch_source_cancel(_timer);
    }
    
    if (_block) _block = nil;
    _totalTime = 0;
    _remainingTime = 0;
    _timestampWithEnterBackground = 0;
    
    if (_backgroundObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:_backgroundObserver];
        _backgroundObserver = nil;
    }
    
    if (_activeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:_activeObserver];
        _activeObserver = nil;
    }
}


- (void)countDownAction {
    if (_block) _block(_remainingTime, NO);
}

- (void)countDownCompletion {
    [self pauseIfNecessary];
    if (_block) _block(0, YES);
}

- (void)pauseIfNecessary {
    if (dispatch_testcancel(_timer)) {
        
    }
    else {
        if (_paused == NO) {
            dispatch_suspend(_timer);
            _paused = YES;
            _resumed = NO;
        }
    }
}

- (void)resumeIfNecessary {
    if (_resumed) {
        if (_paused) {
            if (dispatch_testcancel(_timer)) {
                
            }
            else {
                dispatch_resume(_timer);
                _paused = NO;
                _resumed = YES;
            }
        }
    }
    else {
        if (dispatch_testcancel(_timer)) {
            
        }
        else {
            dispatch_resume(_timer);
            _paused = NO;
            _resumed = YES;
        }
    }
}

- (void)pause {
    [self pauseIfNecessary];
}

- (void)resume {
    [self resumeIfNecessary];
}

- (void)resetTime:(NSTimeInterval)time {
    [self resetTime:time resume:NO];
}

- (void)resetTime:(NSTimeInterval)time resume:(BOOL)resume {
    // 如果是启动状态需要暂停
    BOOL res = _resumed;
    if (res) [self pauseIfNecessary];
    
    // 重新赋值
    self.totalTime = time;
    self.remainingTime = time;
    
    if (resume) {
        [self resumeIfNecessary];
    }
    else {
        // 停留在当前的状态 暂停或者进行中
        if (res) [self resumeIfNecessary];
    }
}

#pragma mark - Notification

- (void)applicationDidEnterBackground {
    _resumedBeforeEnterBackground = _resumed;
    if (_remainingTime > 0) [self pauseIfNecessary];
    if (_resumedBeforeEnterBackground) {
        // 倒计时进行中
        _timestampWithEnterBackground = [NSDate date].timeIntervalSince1970 * (self.intervalMode == MFGlobalCountDownIntervalMsec ? 1000.0 : 1.0);
    }
    else {
        _timestampWithEnterBackground = 0;
    }
    _enterBackground = YES;
}

- (void)applicationDidBecomeActive {
    if (!_enterBackground) return;
    _enterBackground = NO;
    if (_resumedBeforeEnterBackground) {
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970 * (self.intervalMode == MFGlobalCountDownIntervalMsec ? 1000.0 : 1.0) - _timestampWithEnterBackground;
        _remainingTime = MAX(_remainingTime - timeInterval, 0);
        [self resumeIfNecessary];
    }
    _timestampWithEnterBackground = 0;
}

@end
