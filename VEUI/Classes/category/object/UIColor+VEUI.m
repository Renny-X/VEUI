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
    if (hexStr.length == 3) {
        hexStr = [hexStr stringByAppendingString:@"f"];
    }
    if (hexStr.length == 4) {
        NSString *r = [hexStr substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hexStr substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hexStr substringWithRange:NSMakeRange(2, 1)];
        NSString *a = [hexStr substringWithRange:NSMakeRange(3, 1)];
        hexStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", r,r, g,g, b,b, a,a];
    }
    if (hexStr.length == 6) {
        hexStr = [hexStr stringByAppendingString:@"ff"];
    }
    
    NSString *redStr;
    NSString *greenStr;
    NSString *blueStr;
    NSString *alphaStr;
    
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
    
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    [[NSScanner scannerWithString:alphaStr] scanHexInt:&a];

    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
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
