//
//  UIButton+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import "UIButton+VEUI.h"
#import "UIImage+VEUI.h"

@implementation UIButton (VEUI)

- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:state];
}

@end
