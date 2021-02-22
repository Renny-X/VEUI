//
//  NSObject+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import "NSObject+VEUI.h"

@implementation NSObject (VEUI)

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
    if (self == nil || self == [NSNull null]) {
        return @"";
    }
    return self;
}

- (BOOL)isEmpty {
    if ([self isKindOfClass:[NSNull class]] || self == NULL || self == nil) {
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

@end
