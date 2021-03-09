//
//  VETestModel.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/9.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VETestModel.h"

@implementation VETestModel

- (NSDictionary *)reMapKeys {
    NSLog(@"aaaaaaa");
    return @{
        @"subtitle": @"subTitle",
        @"xx": @"test",
    };
}

@end
