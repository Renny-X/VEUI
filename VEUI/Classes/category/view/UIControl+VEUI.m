//
//  UIControl+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/5/6.
//

#import "UIControl+VEUI.h"
#import <objc/runtime.h>

static void * kHitEdgeInsetsKey = &kHitEdgeInsetsKey;

@implementation UIControl (VEUI)

- (void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:hitEdgeInsets];
    objc_setAssociatedObject(self, kHitEdgeInsetsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitEdgeInsets {
    NSValue * value = objc_getAssociatedObject(self, kHitEdgeInsetsKey);
    if(value) {
        return [value UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.hitEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end
