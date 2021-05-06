//
//  NSDictionary+Category.m
//  Vedeng
//
//  Created by Coder on 2020/11/13.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "NSDictionary+VEUI.h"
#import <objc/runtime.h>

#import "NSString+VEUI.h"
#import "NSObject+VEUI.h"

@implementation NSDictionary (VEUI)

+ (NSDictionary *)dictionaryFromJsonStr:(NSString *)jsonStr {
    return [jsonStr toNSDictionary];
}

- (id)safe_valueForKey:(NSString *)aKey {
    id temp = [self objectForKey:aKey];
    if (temp == nil || [temp isEmpty]) {
        temp = @"";
    }
    return temp;
}

- (NSString *)string_valueForKey:(NSString *)aKey {
    id obj = [self valueForKey:aKey];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }
    return @"";
}

- (NSInteger)integer_valueForKey:(NSString *)aKey {
    id obj = [self valueForKey:aKey];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj integerValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj integerValue];
    }
    return 0;
}

- (CGFloat)float_valueForKey:(NSString *)aKey {
    id obj = [self valueForKey:aKey];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj floatValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj floatValue];
    }
    return 0;
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
