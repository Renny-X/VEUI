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
        NSArray *pkeys = reMap.allValues;
        NSArray *dkeys = reMap.allKeys;
        NSArray *properties = [self allProperties];
        for (NSString *propertyName in properties) {
            if ([pkeys containsObject:propertyName]) {
                NSArray *indexArr = [self getAllIndexWithKey:propertyName fromArray:pkeys];
                for (NSNumber *cc in indexArr) {
                    NSInteger index = [cc integerValue];
                    id tmpValue = [dict valueForKey:dkeys[index]];
                    if (tmpValue != nil) {
                        [self handleValue:[dict valueForKey:dkeys[index]] onKey:propertyName];
                    }
                }
            } else if ([dict.allKeys containsObject:propertyName]) {
                [self handleValue:[dict valueForKey:propertyName] onKey:propertyName];
            }
        }
    }
    [self didMapValuesFromDictionary:dict];
    return self;
}

#pragma mark - public
- (NSDictionary *)valueOnModelClass {
    // key --> className
    return @{};
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

- (void)didMapValuesFromDictionary:(NSDictionary *)dict {}

#pragma mark - Data Handler
- (void)handleValue:(id)value onKey:(NSString *)key {
    if (![self reMapValue:value onKey:key]) {
        id obj = value;
        NSDictionary *vmDict = [self valueOnModelClass];
        if (
            [vmDict.allKeys containsObject:key]
            && (
                [obj isKindOfClass:[NSArray class]]
                || [obj isKindOfClass:[NSDictionary class]]
            )
        ) {
            NSString *className = [vmDict objectForKey:key];
            Class modelClass = NSClassFromString(className);
            if ([self isSubclass:modelClass]) {
                if ([value isKindOfClass:[NSArray class]]){
                    // Array
                    NSMutableArray *tmpArr = [NSMutableArray array];
                    NSArray *valueArr = (NSArray *)value;
                    for (int i = 0; i < valueArr.count; i++) {
                        NSDictionary *vdict = valueArr[i];
                        id modelValue = [[modelClass alloc] initWithDictionary:vdict];
                        [tmpArr addObject: modelValue];
                    }
                    obj = [NSArray arrayWithArray:tmpArr];
                } else {
                    // Dictionary
                    obj = [[modelClass alloc] initWithDictionary:value];
                }
            }
        }
        [self setValue:obj forKey:key];
    }
}

- (NSArray *)getAllIndexWithKey:(NSString *)key fromArray:(NSArray *)source {
    if (!key || !key.length || !source || !source.count) {
        return @[];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < source.count; i++) {
        NSString *tmpKey = source[i];
        if ([tmpKey isEqualToString:key]) {
            [arr addObject:[NSNumber numberWithInt:i]];
        }
    }
    return arr;
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

- (BOOL)isSubclass:(Class)class {
    BOOL flag = NO;
    Class superClass = class_getSuperclass(class);
    while (superClass) {
        if (superClass == [VEModel class]) {
            flag = YES;
            break;
        }
        superClass = class_getSuperclass(superClass);
    }
    return flag;
}

#pragma mark - NSLog
- (NSString *)description {
    return [[self dictionaryValue] description];
}

@end
