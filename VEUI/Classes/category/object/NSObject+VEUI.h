//
//  NSObject+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VEUI)
/**
 * 字符串tag，跟tag一样的作用
 */
@property (nonatomic, strong) NSString *__nullable strTag;


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
/**
 * 判断obj是否为Nil、Null 或 空字符串、空数组、空字典等
 */
+ (BOOL)isNilorNull:(id)obj;

#pragma mark - KVO
/**
 * 是否包含KVO keyPath
 */
- (BOOL)containObserver:(id)observer forKeyPath:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
