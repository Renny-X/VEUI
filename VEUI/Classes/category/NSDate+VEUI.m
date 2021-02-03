//
//  NSDate+Category.m
//  Vedeng
//
//  Created by Coder on 2020/11/16.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "NSDate+VEUI.h"

@implementation NSDate (VEUI)

+ (NSString *)timeStamp {
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
}

@end
