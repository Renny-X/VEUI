//
//  NSArray+Category.m
//  Vedeng
//
//  Created by Coder on 2020/11/13.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <objc/runtime.h>
#import "NSArray+VEUI.h"
#import "NSString+VEUI.h"
#import "NSObject+VEUI.h"
#import "VETools.h"

@implementation NSArray (VEUI)

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}


+ (NSArray *)arrayFromJsonStr:(NSString *)jsonStr {
    return [jsonStr toNSArray];
}

//输出中文字符串
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(replaceDescription)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(replaceDescriptionWithLocale:indent:)));
}

- (NSString *)replaceDescription {
    return [NSObject stringByReplaceUnicode:[self replaceDescription]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale {
    return [NSObject stringByReplaceUnicode:[self replaceDescriptionWithLocale:locale]];
}

- (NSString *)replaceDescriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [NSObject stringByReplaceUnicode:[self replaceDescriptionWithLocale:locale indent:level]];
}

@end

@implementation NSMutableArray (VEUI)

- (void)safe_addObject:(id)obj {
    if (obj == nil) {
        return [self addObject:@""];
    }
    [self addObject:obj];
}

- (void)safe_addObjectFromArray:(NSArray *)arr {
    if ([NSObject isNilorNull:arr]) {
        return;
    }
    if ([arr isKindOfClass:[NSArray class]]) {
        [self addObjectsFromArray:arr];
    }
}

- (void)safe_insertOjbect:(id)obj atIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return;
    }
    if (obj == nil) {
        return [self insertObject:@"" atIndex:index];
    } else {
        [self insertObject:obj atIndex:index];
    }
}

- (void)safe_removeObjectAtIndex:(NSInteger)index {
    if (self.count > index) {
        [self removeObjectAtIndex:index];
    }
}

- (void)safe_removeObjectsInRange:(NSRange)range {
    if (!NSRangeContainRange(NSMakeRange(0, self.count), range)) {
        return;
    }
    [self removeObjectsInRange:range];
}

- (void)safe_replaceObjectAtIndex:(NSInteger)index withObject:(id)obj {
    if (self.count > index) {
        [self replaceObjectAtIndex:index withObject:obj];
    }
}

- (void)safe_replaceObjectsInRange:(NSRange)range withObjects:(NSArray *)arr {
    if (!NSRangeContainRange(NSMakeRange(0, self.count), range)) {
        return;
    }
    [self replaceObjectsInRange:range withObjectsFromArray:arr];
}

@end
