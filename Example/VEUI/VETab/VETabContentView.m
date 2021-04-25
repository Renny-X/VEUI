//
//  VETabContentView.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/17.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VETabContentView.h"

@implementation VETabContentView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
        [self fakeLoadData];
    }
    return self;
}

- (void)fakeLoadData {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSThread sleepForTimeInterval:1.5];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//            view.backgroundColor = [UIColor greenColor];
//            [self addSubview:view];
//        });
//    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.clickBack) {
        self.clickBack(YES);
    }
}

@end
