//
//  NSString+Category.m
//  Vedeng
//
//  Created by Coder on 2020/11/16.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "NSString+VEUI.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSObject+VEUI.h"

@implementation NSString (VEUI)

// 中文 转 utf-8
- (NSString *)urlString {
    NSString *url = self;
    if (url == nil || url.length == 0) {
        url = @" ";
    }
    NSString *charactersToEscape = @"\"%<>[\\]^`{|}";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

// utf-8 转 中文
- (NSString *)decodeUrlString {
    if (self == nil) {
        return @"";
    }
    return [self stringByRemovingPercentEncoding];
}

- (NSDictionary *)toNSDictionary {
    NSData *json = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    id dict = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return dict;
    }
    return nil;
}

- (NSArray *)toNSArray {
    NSData *json = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    id arr = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    if ([arr isKindOfClass:[NSArray class]]) {
        return arr;
    }
    return nil;
}

- (NSArray<NSDictionary *> *)rangeDictionaryArrayOfSubstring:(NSString *)sub {
    if ([NSObject isNilorNull:sub]) {
        return @[];
    }
    NSString *cc = [self mutableCopy];
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *tmpArr = [cc componentsSeparatedByString:sub];
    if (tmpArr) {
        NSInteger prefixLength = 0;
        if ([cc hasPrefix:sub]) {
            [marr addObject:@{
                @"location": [NSNumber numberWithInteger:0],
                @"length": [NSNumber numberWithInteger:sub.length],
            }];
            tmpArr = [tmpArr subarrayWithRange:NSMakeRange(1, tmpArr.count - 1)];
            prefixLength = sub.length;
        }
        for (int i = 0; i < tmpArr.count; i++) {
            NSArray *ss = [tmpArr subarrayWithRange:NSMakeRange(0, i + 1)];
            NSInteger location = [ss componentsJoinedByString:sub].length + prefixLength;
            if (location + sub.length <= cc.length) {
                [marr addObject:@{
                    @"location": [NSNumber numberWithInteger:location],
                    @"length": [NSNumber numberWithInteger:sub.length],
                }];
            } else {
                break;
            }
        }
    }
    return marr;
}

+ (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

- (NSString *)md5String {
    const char* original_str=[self UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

#pragma mark - Validate
- (BOOL)isEmail {
//    /\w[-\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\.)+[A-Za-z]{2,14}/
    NSString *emailReg = @"\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPhone {
//    /^((1[3,8][0-9])|(14[1456789])|(15([012356789]))|(16[2567])|(17[01235678])|(19[189]))\d{8}$/
    NSString *phoneReg = @"^((1[3,8][0-9])|(14[1456789])|(15([012356789]))|(16[2567])|(17[01235678])|(19[189]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneReg];
    return [phoneTest evaluateWithObject:self];
    return YES;
}

/**
 * 校验是否为纯链接
 */
- (BOOL)isUrlString {
    NSError* error = nil;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arr = [linkDetector matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *result in arr) {
        NSRange range = [result range];
        if (range.location == 0 && range.length == self.length) {
            NSURL *url = [result URL];
            if (![url.scheme isEqual:@"tel"]) {
                return YES;
            }
        }
    }
    return NO;
}

/**
 * 是否包含中文
 */
- (BOOL)containsCN {
    for(int i=0; i< [self length];i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Calculate
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size {
    if (!self.length || !font) {
        return CGSizeZero;
    }
    CGSize tmpSize = [self boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil].size;
    return CGSizeMake(ceilf(tmpSize.width), ceilf(tmpSize.height));
}

- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    return [self sizeWithFont:font maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX)].height;
}

@end
