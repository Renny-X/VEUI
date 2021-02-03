//
//  NSArray+Category.m
//  Vedeng
//
//  Created by Coder on 2020/11/13.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "NSArray+VEUI.h"
#import "NSString+VEUI.h"

@implementation NSArray (VEUI)

+ (NSArray *)arrayFromJsonStr:(NSString *)jsonStr {
    return [jsonStr toNSArray];
}

@end
