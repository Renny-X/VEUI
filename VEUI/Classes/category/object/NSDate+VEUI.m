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

+ (NSDate *)dateWithDateString:(NSString *)dateStr formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateStr];
}

+ (NSString *)dateStringWithFormatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return date;
}

- (NSString *)format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:self];
    return date;
}

- (NSString *)timeStamp {
    return [NSString stringWithFormat:@"%.0f",[self timeIntervalSince1970] * 1000];
}

@end
