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
    // model.property --> data.key
    return @{
        @"subtitle": @"subTitle",
        @"test": @"des",
    };
}
- (BOOL)reMapValue:(id)value onKey:(NSString *)key {
    if ([key isEqualToString:@"subModel"]) {
        self.subModel = [[VETestSonSubModel alloc] initWithDictionary:value];
        return YES;
    }
    return nil;
}

@end
