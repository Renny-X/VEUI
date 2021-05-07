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

- (id)safe_objectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (VEUI)

- (void)safe_addObject:(id)obj;

- (void)safe_addObjectFromArray:(NSArray *)arr;

- (void)safe_insertOjbect:(id)obj atIndex:(NSInteger)index;

- (void)safe_removeObjectAtIndex:(NSInteger)index;

- (void)safe_removeObjectsInRange:(NSRange)range;

- (void)safe_replaceObjectAtIndex:(NSInteger)index withObject:(id)obj;

- (void)safe_replaceObjectsInRange:(NSRange)range withObjects:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
