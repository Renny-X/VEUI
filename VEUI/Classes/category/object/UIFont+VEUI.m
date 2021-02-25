//
//  UIFont+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/22.
//

#import "UIFont+VEUI.h"
#import <CoreText/CoreText.h>
#import "VEUIDEVTool.h"
#import "NSObject+VEUI.h"

@implementation UIFont (VEUI)

+ (nullable UIFont *)VEFontWithSize:(CGFloat)fontSize {
    NSString *fontName = [UIFont VEFontName];
    if (![fontName isEmpty]) {
        return [UIFont fontWithName:fontName size:fontSize];
    }
    return [UIFont systemFontOfSize:fontSize];
}

+ (NSString *)VEFontName {
    NSBundle *bundle = [VEUIDEVTool vebundle];
    NSURL *fontURL = [bundle URLForResource:@"HC" withExtension:@"ttf"];
    
    NSData *inData = [NSData dataWithContentsOfURL:fontURL];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        CFRelease(errorDescription);
    }
    if (provider) {
        CFRelease(provider);
    }
    if (font) {
        NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(font));
        CFRelease(font);
        return fontName;
    }
    return @"";
}

@end
