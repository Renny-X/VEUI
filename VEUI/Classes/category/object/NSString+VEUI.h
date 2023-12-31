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
 * 返回所有子字符串的range { @"location": @0, @"length": @0 }
 */
- (NSArray<NSDictionary *> *)rangeDictionaryArrayOfSubstring:(NSString *)sub;
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
/**
 * 校验是否为纯链接
 */
- (BOOL)isUrlString;
/**
 * 是否包含中文
 */
- (BOOL)containsCN;

#pragma mark - Calculate
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size;
- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

@end

NS_ASSUME_NONNULL_END
