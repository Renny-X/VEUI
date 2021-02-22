//
//  NSObject+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VEUI)

+ (NSString *)stringByReplaceUnicode:(NSString *)string;
/**
 * 转 Json字符串, 失败时返回空字符串
 */
- (NSString *)JSONString;
/**
 * 将NSArray、NSDictionary中null 替换为 @"" 空字符串
 */
- (id)formatValue;
/**
 * 判断是否为Null 或 空字符串、空数组、空字典等
 */
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
