//
//  NSDate+Category.h
//  Vedeng
//
//  Created by Coder on 2020/11/16.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (VEUI)

/**
 * timeStamp: 获取当前时间戳
 */
+ (NSString *)timeStamp;
/**
 * 通过时间字符串 + format字符串 返回NSDate
 */
+ (NSDate *)dateWithDateString:(NSString *)dateStr formatter:(NSString *)format;
/**
 * 返回format格式 当前时间字符串
 */
+ (NSString *)dateStringWithFormatter:(NSString *)format;
/**
 * 返回format格式 时间字符串
 */
- (NSString *)format:(NSString *)format;
/**
 * timeStamp: 获取对应的时间戳
 */
- (NSString *)timeStamp;

@end

NS_ASSUME_NONNULL_END
