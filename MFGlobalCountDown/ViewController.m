//
//  ViewController.m
//  MFGlobalCountDown
//
//  Created by Tim on 2020/4/21.
//  Copyright © 2020 Tim. All rights reserved.
//

#import "ViewController.h"
#import "MFGlobalCountDown.h"
#import "MFCountDownDisplayTool.h"

@interface ViewController ()
/**
 倒计时
 */
@property (nonatomic, strong) MFGlobalCountDown *countDown;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.center = self.view.center;
    [self.view addSubview:label];
//    self.countDown = [MFGlobalCountDown countDownWithTime:1000 * 10 block:^(NSTimeInterval remainingTime, BOOL isComplete) {
//        if (isComplete) {
//            label.hidden = YES;
//        } else {
//            label.text = [MFCountDownDisplayTool getCountDownTimeStringAccordMillisecondWithNoSpacing:remainingTime];
//        }
//    }];
    
    self.countDown = [MFGlobalCountDown countDownWithTime:1000 * 20 interval:1 block:^(NSTimeInterval remainingTime, BOOL isComplete) {
        if (isComplete) {
            label.hidden = YES;
        } else {
            label.text = [MFCountDownDisplayTool getCountDownTimeStringAccordMillisecondWithNoSpacing:remainingTime];
        }

    }];
}


@end
