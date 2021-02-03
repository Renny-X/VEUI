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

- (NSDictionary *)toNSDictionary;

- (NSArray *)toNSArray;

+ (NSString *)uuidString;

- (NSString *)md5String;

#pragma mark - Validate
- (BOOL)isEmail;

- (BOOL)isPhone;

@end

NS_ASSUME_NONNULL_END
