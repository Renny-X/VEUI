//
//  NSString+Category.h
//  Vedeng
//
//  Created by Coder on 2020/11/16.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (VEUI)

/**
 * urlString: 中文 转 utf-8
 */
- (NSString *)urlString;
/**
 * decodeUrlString: utf-8 转 中文
 */
- (NSString *)decodeUrlString;
/**
 * NSString (JSON) 转 NSDictionary
 */
- (NSDictionary *)toNSDictionary;
/**
 * NSString (JSON) 转 NSArray
 */
- (NSArray *)toNSArray;
/**
 * 返回随机 UUID 字符串
 */
+ (NSString *)uuidString;
/**
 * 返回随机 md5 字符串
 */
- (NSString *)md5String;

#pragma mark - Validate
/**
 * 校验是否为合法邮箱地址
 */
- (BOOL)isEmail;
/**
 * 校验是否为合法手机号
 */
- (BOOL)isPhone;

@end

NS_ASSUME_NONNULL_END