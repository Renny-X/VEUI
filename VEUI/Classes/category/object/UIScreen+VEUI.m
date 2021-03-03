//
//  UIScreen+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import "UIScreen+VEUI.h"

@implementation UIScreen (VEUI)

+ (CGFloat)width {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)height {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGSize)size {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGRect)bounds {
    return [UIScreen mainScreen].bounds;
}

@end
