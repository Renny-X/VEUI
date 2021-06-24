//
//  NSObject+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import "NSObject+VEUI.h"
#import <objc/runtime.h>

@implementation NSObject (VEUI)

//Category
- (void)setStrTag:(NSString *)strTag{
    objc_setAssociatedObject(self, @selector(strTag), strTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)strTag{
    return objc_getAssociatedObject(self, @selector(strTag));
}

+ (NSString *)stringByReplaceUnicode:(NSString *)string {
    NSMutableString *convertedString = [string mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}

- (NSString *)JSONString {
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!json) {
        NSLog(@"JSONString Got an error: %@", error);
        return @"";
    }
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

- (id)formatValue {
    if ([self isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:(NSArray *)self];
        for (int i = 0; i < tmpArr.count; i++) {
            id tmpValue = tmpArr[i];
            if ([tmpValue isKindOfClass:[NSArray class]] || [tmpValue isKindOfClass:[NSDictionary class]]) {
                [tmpArr replaceObjectAtIndex:i withObject:[tmpValue formatValue]];
            }
            if (tmpValue == nil || tmpValue == [NSNull null]) {
                [tmpArr replaceObjectAtIndex:i withObject:@""];
            }
        }
        return tmpArr;
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)self];
        NSArray *allKeys = [tmpDict allKeys];
        for (int i = 0; i < allKeys.count; i++) {
            NSString *key = allKeys[i];
            id tmpValue = [tmpDict objectForKey:key];
            if ([tmpValue isKindOfClass:[NSArray class]] || [tmpValue isKindOfClass:[NSDictionary class]]) {
                [tmpDict setValue:[tmpValue formatValue] forKey:key];
            }
            if (tmpValue == nil || tmpValue == [NSNull null]) {
                [tmpDict setValue:@"" forKey:key];
            }
        }
        return tmpDict;
    }
    if (self == nil || [self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return self;
}

- (BOOL)isEmpty {
    if ([self isKindOfClass:[NSNull class]]) {
        return true;
    }
    if ([self isKindOfClass:[NSString class]]) {
        return !((NSString *)self).length;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        return !((NSArray *)self).count;
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        return !((NSDictionary *)self).allKeys.count;
    }
    return false;
}

+ (BOOL)isNilorNull:(id)obj {
    if (obj == nil) {
        return true;
    }
    return [obj isEmpty];
}

#pragma mark - Load
+ (void)load {
    method_exchangeImplementations(
        class_getClassMethod([self class], @selector(addObserver:forKeyPath:options:context:)),
        class_getClassMethod([self class], @selector(safeAddObserver:forKeyPath:options:context:))
    );
}

#pragma mark - KVO
- (void)safeAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if (![self containObserver:observer forKeyPath:keyPath]) {
        [self safeAddObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (BOOL)containObserver:(id)observer forKeyPath:(NSString *)key {
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        id newObserver = [objc valueForKeyPath:@"_observer"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath] && [newObserver isEqual:observer]) {
            return YES;
        }
    }
    return NO;
}


@end
