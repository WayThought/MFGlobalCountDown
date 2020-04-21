//
//  MFCountDownDisplayTool.h
//  MFGlobalCountDown
//
//  Created by Tim on 2020/4/21.
//  Copyright © 2020 Tim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFCountDownDisplayTool : NSObject

/**
 获取拼接后的倒计时文字 显示毫秒

 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getCountDownTimeStringAccordMillisecond:(NSInteger)countDownTime;


/**
 获取未拼接的倒计时文字 含毫秒位

 @param countDownTime 倒计时时间
 @return 各位时间数组
 */
+ (NSArray<NSString *> *)getCountDownTimeSeparateStringAccordMillisecond:(NSInteger)countDownTime;

/**
 获取拼接后的倒计时文字 显示毫秒 没有空格
 
 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getCountDownTimeStringAccordMillisecondWithNoSpacing:(NSInteger)countDownTime;

/**
 获取拼接后的倒计时文字 显示秒
 
 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getCountDownTimeStringAccordSecond:(NSInteger)countDownTime;

/**
 获取拼接后的倒计时文字 显示 小时：分钟：秒（不会换算成天）  xx：xx：xx
 
 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getHourCountDownTimeStringAccordSecond:(NSInteger)countDownTime;

/**
 获取拼接后的倒计时文字 显示 小时：分钟：秒：毫秒（不会换算成天）  xx：xx：xx：x
 
 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getHourCountDownTimeStringAccordMilliSecond:(NSInteger)countDownTime;

@end

NS_ASSUME_NONNULL_END
