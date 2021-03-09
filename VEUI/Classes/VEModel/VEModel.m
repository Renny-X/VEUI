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
        NSArray *dkeys = reMap.allKeys;
        NSArray *pkeys = reMap.allValues;
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char* char_f =property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            if ([pkeys containsObject:propertyName]) {
                NSInteger index = [pkeys indexOfObject:propertyName];
                [self setValue:[dict valueForKey:dkeys[index]] forKey:propertyName];
            } else if ([dict.allKeys containsObject:propertyName]) {
                [self setValue:[dict valueForKey:propertyName] forKey:propertyName];
            }
        }
    }
    return self;
}

- (NSDictionary *)reMapKeys {
    return @{};
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSString *)debugDescription {
    return [[self dictionaryValue] description];
}

@end
