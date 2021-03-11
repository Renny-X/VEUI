//
//  VEModel.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/9.
//

#import "VEModel.h"
#import <objc/runtime.h>

@implementation VEModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSDictionary *reMap = [self reMapKeys];
        NSArray *pkeys = reMap.allKeys;
        NSArray *dkeys = reMap.allValues;
        NSArray *properties = [self allProperties];
        for (NSString *propertyName in properties) {
            if ([pkeys containsObject:propertyName]) {
                NSInteger index = [pkeys indexOfObject:propertyName];
                [self handleValue:[dict valueForKey:dkeys[index]] onKey:propertyName];
            } else if ([dict.allKeys containsObject:propertyName]) {
                [self handleValue:[dict valueForKey:propertyName] onKey:propertyName];
            }
        }
    }
    return self;
}

- (NSArray *)allProperties {
    NSMutableArray *tmpArr = [NSMutableArray array];
    Class target = [self class];
    unsigned int outCount;
    while (target != [VEModel class]) {
        objc_property_t *properties = class_copyPropertyList(target, &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char* char_f =property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            [tmpArr addObject:propertyName];
        }
        target = class_getSuperclass(target);
    }
    return tmpArr;
}

- (void)handleValue:(id)value onKey:(NSString *)key {
    if (![self reMapValue:value onKey:key]) {
        [self setValue:value forKey:key];
    }
}

- (NSDictionary *)reMapKeys {
    return @{};
}

- (BOOL)reMapValue:(id)value onKey:(NSString *)key {
    return NO;
}

- (NSDictionary *)dictionaryValue {
    NSArray *arr = [self allProperties];
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    for (int i = 0; i < arr.count; i++) {
        NSString *propertyName = arr[i];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    return props;
}

- (NSString *)description {
    return [[self dictionaryValue] description];
}

@end
