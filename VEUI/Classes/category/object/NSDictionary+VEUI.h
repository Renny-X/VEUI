//
//  NSDictionary+Category.h
//  Vedeng
//
//  Created by Coder on 2020/11/13.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (VEUI)

/**
 * Json 字符串转 NSDictionary
 */
+ (NSDictionary *)dictionaryFromJsonStr:(NSString *)jsonStr;
/**
 * key-value 为null时 返回 @"" 空字符串
 */
- (id)safe_valueForKey:(NSString *)aKey;

- (NSString *)string_valueForKey:(NSString *)aKey;

- (NSInteger)integer_valueForKey:(NSString *)aKey;

- (CGFloat)float_valueForKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
