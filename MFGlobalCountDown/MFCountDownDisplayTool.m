//
//  MFCountDownDisplayTool.m
//  MFGlobalCountDown
//
//  Created by Tim on 2020/4/21.
//  Copyright © 2020 Tim. All rights reserved.
//

#import "MFCountDownDisplayTool.h"

@implementation MFCountDownDisplayTool
NSString * transNumToString(int num, bool milli) {
    return [NSString stringWithFormat:(milli?@"%01d":@"%02d"),num];
}

+ (NSString *)getCountDownTimeStringAccordMillisecond:(NSInteger)countDownTime {
    
    NSInteger countDownLeftTime = countDownTime / 100;
    int dayValue = 0;
    int hourValue = 0;
    int minuteValue = 0;
    int secondValue = 0;
    int millisecond = 0;
    
    dayValue = (int)(countDownLeftTime / 36000 / 24);
    hourValue = (int)(countDownLeftTime / 36000 % 24);
    minuteValue = (int)(countDownLeftTime /10 % 3600 / 60);
    secondValue = (int)(countDownLeftTime /10 % 60);
    millisecond = countDownLeftTime % 10;
    // 如果含有天数
    if (dayValue > 0) {
        return  [NSString stringWithFormat:@"%02d 天 %02d : %02d : %02d . %01d", dayValue,hourValue,minuteValue,secondValue,millisecond];
    } else {
        return  [NSString stringWithFormat:@"%02d : %02d : %02d . %01d", hourValue,minuteValue,secondValue,millisecond];
    }
}

+ (NSArray<NSString *> *)getCountDownTimeSeparateStringAccordMillisecond:(NSInteger)countDownTime {
    NSInteger countDownLeftTime = countDownTime / 100;
    int dayValue = 0;
    int hourValue = 0;
    int minuteValue = 0;
    int secondValue = 0;
    int millisecond = 0;
    
    dayValue = (int)(countDownLeftTime / 36000 / 24);
    hourValue = (int)(countDownLeftTime / 36000 % 24);
    minuteValue = (int)(countDownLeftTime /10 % 3600 / 60);
    secondValue = (int)(countDownLeftTime /10 % 60);
    millisecond = countDownLeftTime % 10;
    // 如果含有天数
    if (dayValue > 0) {
        return @[
                 transNumToString(dayValue,     false),
                 transNumToString(hourValue,    false),
                 transNumToString(minuteValue,  false),
                 transNumToString(secondValue,  false),
                 transNumToString(millisecond,  true)
                 ];
    } else {
        return @[
                 transNumToString(hourValue,    false),
                 transNumToString(minuteValue,  false),
                 transNumToString(secondValue,  false),
                 transNumToString(millisecond,  true)
                 ];
    }
}

+ (NSString *)getCountDownTimeStringAccordMillisecondWithNoSpacing:(NSInteger)countDownTime {
    
    NSInteger countDownLeftTime = countDownTime / 100;
    int dayValue = 0;
    int hourValue = 0;
    int minuteValue = 0;
    int secondValue = 0;
    int millisecond = 0;
    
    dayValue = (int)(countDownLeftTime / 36000 / 24);
    hourValue = (int)(countDownLeftTime / 36000 % 24);
    minuteValue = (int)(countDownLeftTime /10 % 3600 / 60);
    secondValue = (int)(countDownLeftTime /10 % 60);
    millisecond = countDownLeftTime % 10;
    // 如果含有天数
    if (dayValue > 0) {
        return  [NSString stringWithFormat:@"%02d天%02d:%02d:%02d.%01d", dayValue,hourValue,minuteValue,secondValue,millisecond];
    } else {
        return  [NSString stringWithFormat:@"%02d:%02d:%02d.%01d", hourValue,minuteValue,secondValue,millisecond];
    }
}

+ (NSString *)getCountDownTimeStringAccordSecond:(NSInteger)countDownTime {
    int dayValue = 0;
    int hourValue = 0;
    int minuteValue = 0;
    int secondValue = 0;
    
    dayValue = (int)(countDownTime / 60 / 60 / 24);
    hourValue = (int)((countDownTime - dayValue * 3600 * 24) / 3600);
    minuteValue = (int)((countDownTime - dayValue * 3600 * 24 - hourValue * 3600) / 60);
    secondValue = (int)((countDownTime - dayValue * 3600 * 24 - hourValue * 3600 - 60 * minuteValue));
    // 如果含有天数
    if (dayValue > 0) {
        return  [NSString stringWithFormat:@"%02d 天 %02d : %02d : %02d", dayValue,hourValue,minuteValue,secondValue];
    } else {
        return  [NSString stringWithFormat:@"%02d : %02d : %02d", hourValue,minuteValue,secondValue];
    }
}


/**
 获取拼接后的倒计时文字 显示 小时：分钟：秒（不会换算成天）  xx：xx：xx
 
 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getHourCountDownTimeStringAccordSecond:(NSInteger)countDownTime {
    int hourValue = 0;
    int minuteValue = 0;
    int secondValue = 0;
    
    hourValue = (int)((countDownTime) / 3600);
    minuteValue = (int)((countDownTime - hourValue * 3600) / 60);
    secondValue = (int)((countDownTime - hourValue * 3600 - 60 * minuteValue));
    return  [NSString stringWithFormat:@"%02d : %02d : %02d", hourValue,minuteValue,secondValue];
}

/**
 获取拼接后的倒计时文字 显示 小时：分钟：秒：毫秒（不会换算成天）  xx：xx：xx：x
 
 @param countDownTime 倒计时时间
 @return 拼接后的倒计时文字
 */
+ (NSString *)getHourCountDownTimeStringAccordMilliSecond:(NSInteger)countDownTime {
    NSInteger countDownLeftTime = countDownTime / 100;
    int hourValue = 0;
    int minuteValue = 0;
    int secondValue = 0;
    int millisecond = 0;
    
    hourValue = (int)(countDownLeftTime / 36000);
    minuteValue = (int)(countDownLeftTime /10 % 3600 / 60);
    secondValue = (int)(countDownLeftTime /10 % 60);
    millisecond = countDownLeftTime % 10;
    // 如果含有天数
    return  [NSString stringWithFormat:@"%02d : %02d : %02d . %01d", hourValue,minuteValue,secondValue,millisecond];
}

@end
