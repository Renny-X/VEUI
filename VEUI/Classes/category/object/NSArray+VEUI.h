//
//  NSArray+Category.h
//  Vedeng
//
//  Created by Coder on 2020/11/13.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (VEUI)

/**
 * Json 字符串转 NSArray
 */
+ (NSArray *)arrayFromJsonStr:(NSString *)jsonStr;

@end

NS_ASSUME_NONNULL_END
