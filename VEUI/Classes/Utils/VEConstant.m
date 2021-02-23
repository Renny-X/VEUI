
#import "VEConstant.h"

NSString *VD_EncodeStringFromDic(NSDictionary *dic, NSString *key)
{
    if (nil != dic && [dic isKindOfClass:[NSDictionary class]]) {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSString class]]) {
            return temp;
        }
        else if ([temp isKindOfClass:[NSNumber class]]) {
            return [temp stringValue];
        }
    }
    return @"";
}

NSNumber *VD_EncodeNumberFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithDouble:[temp doubleValue]];
    }
    else if ([temp isKindOfClass:[NSNumber class]]) {
        return temp;
    }
    return nil;
}

BOOL VD_EncodeBoolFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    id temp = [dic objectForKey:key];
    if ([temp respondsToSelector:@selector(boolValue)]) {
        return [temp boolValue];
    }
    return NO;
}

NSDictionary *VD_EncodeDicFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSDictionary class]]) {
        return temp;
    }
    return nil;
}

id VD_EncodeObjectFromDic(NSDictionary *dic, NSString *key,Class objectClass)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:objectClass]) {
        return temp;
    }
    return nil;
}

NSArray *VD_EncodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]]) {
        return temp;
    }
    return nil;
}

NSArray *VD_EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key,
                                           id(^parseBlock)(id innerDic))
{
    NSArray *tempList = VD_EncodeArrayFromDic(dic, key);
    if (tempList) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tempList count]];
        for (NSDictionary *item in tempList) {
            if (parseBlock) {
                id dto = parseBlock(item);
                if (dto) {
                    [array addObject:dto];
                }
            }
        }
        return array;
    }
    return nil;
}

NSArray *VD_ParseArrayWithBlock(NSArray *tempList,
                                id(^parseBlock)(id innerDic))
{
    if (![tempList isKindOfClass:[NSArray class]]) {
        return nil;
    }
    if (tempList) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tempList count]];
        for (NSDictionary *item in tempList) {
            if (parseBlock) {
                id dto = parseBlock(item);
                if (dto) {
                    [array addObject:dto];
                }
            }
        }
        return array;
    }
    return nil;
}


UIColor *VE_ColorWithHexString(NSString *color,CGFloat alpha)
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
UIColor *colorWithHexString(NSString *color)
{
    return VE_ColorWithHexString(color, 1.0);
}

@implementation VEConstant

@end
