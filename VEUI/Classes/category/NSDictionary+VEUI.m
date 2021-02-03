//
//  NSDictionary+Category.m
//  Vedeng
//
//  Created by Coder on 2020/11/13.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "NSDictionary+VEUI.h"
#import "NSString+VEUI.h"

@implementation NSDictionary (VEUI)

+ (NSDictionary *)dictionaryFromJsonStr:(NSString *)jsonStr {
    return [jsonStr toNSDictionary];
}

- (NSString *)toJsonString {
    NSString *jsonString = nil;
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!json) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
