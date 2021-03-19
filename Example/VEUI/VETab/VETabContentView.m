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
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.clickBack) {
        self.clickBack(YES);
    }
}

@end
