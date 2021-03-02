//
//  UIColor+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/3.
//

#import "UIColor+VEUI.h"

@implementation UIColor (VEUI)

+ (UIColor *)colorWithHexString:(NSString *)hexStr {
    hexStr = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    hexStr = [hexStr lowercaseString];
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (hexStr.length != 3 && hexStr.length != 4 && hexStr.length != 6 && hexStr.length != 8) {
        return [UIColor clearColor];
    }
    
    float fn = 1.0;
    
    NSString *redStr;
    NSString *greenStr;
    NSString *blueStr;
    NSString *alphaStr;
    if (hexStr.length == 3 || hexStr.length == 4) {
        fn = 15.0;
        NSRange range;
        range.location = 0;
        range.length = 1;
        redStr = [hexStr substringWithRange:range];
        range.location = 1;
        greenStr = [hexStr substringWithRange:range];
        range.location = 2;
        blueStr = [hexStr substringWithRange:range];
        range.location = 3;
        alphaStr = hexStr.length == 4 ? [hexStr substringWithRange:range] : @"f";
    }
    if (hexStr.length == 6 || hexStr.length == 8) {
        NSRange range;
        range.location = 0;
        range.length = 2;
        redStr = [hexStr substringWithRange:range];
        range.location = 2;
        greenStr = [hexStr substringWithRange:range];
        range.location = 4;
        blueStr = [hexStr substringWithRange:range];
        range.location = 6;
        alphaStr = hexStr.length == 8 ? [hexStr substringWithRange:range] : @"ff";
    }
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    [[NSScanner scannerWithString:alphaStr] scanHexInt:&a];

    return [UIColor colorWithRed:((float)r * fn / 255.0f) green:((float)g * fn / 255.0f) blue:((float)b * fn / 255.0f) alpha:((float)a * fn / 255.0f)];
}

- (UIColor *)inverseColor {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.0 - r green:1.0 - g blue:1.0 - b alpha:1.0 - a];
}

- (UIColor *)colorWithAlpha:(CGFloat)alpha {
    CGFloat r, g, b;
    [self getRed:&r green:&g blue:&b alpha:nil];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end
