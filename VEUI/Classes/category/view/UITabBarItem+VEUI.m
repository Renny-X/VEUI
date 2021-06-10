//
//  UITabBarItem+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/6/9.
//

#import "UITabBarItem+VEUI.h"
#import "VEUI.h"
#import "UIView+VEUI.h"
#import <objc/runtime.h>

@implementation UITabBarItem (VEUI)

- (void)setBadgeDotColor:(UIColor *)badgeDotColor {
    objc_setAssociatedObject(self, @selector(badgeDotColor), badgeDotColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UIImageView *imgV = [self getSwappableView];
    if (imgV == nil) {
        return;
    }
    UIView *dotV = [self getBadgeDotView];
    if (dotV == nil) {
        return;
    }
    dotV.backgroundColor = badgeDotColor;
}

- (UIColor *)badgeDotColor {
    UIColor *color = objc_getAssociatedObject(self, @selector(badgeDotColor));
    if (color == nil) {
        color = UIColor.redColor;
    }
    return color;
}

- (void)setBadgeDotWidth:(CGFloat)badgeDotWidth {
    objc_setAssociatedObject(self, @selector(badgeDotWidth), @(badgeDotWidth), OBJC_ASSOCIATION_ASSIGN);
    [self updateBadgeDotCenter];
}

- (CGFloat)badgeDotWidth {
    CGFloat width = [objc_getAssociatedObject(self, @selector(badgeDotWidth)) floatValue];
    if (width == 0) {
        width = 8;
    }
    return width;
}

- (void)setShowBadgeDot:(BOOL)showBadgeDot {
    objc_setAssociatedObject(self, @selector(showBadgeDot), @(showBadgeDot), OBJC_ASSOCIATION_ASSIGN);

    UIView *dotV = [self getBadgeDotView];
    if (dotV == nil) {
        return;
    }
    dotV.hidden = self.badgeValue == nil ? !showBadgeDot : YES;
}

- (BOOL)showBadgeDot {
    return [objc_getAssociatedObject(self, @selector(showBadgeDot)) boolValue];
}

- (void)updateBadgeDotCenter {
    UIImageView *imgV = [self getSwappableView];
    UIView *dotV = [self getBadgeDotView];
    if (imgV == nil || dotV == nil) {
        return;
    }
    dotV.size = CGSizeMake(self.badgeDotWidth, self.badgeDotWidth);
    dotV.center = CGPointMake(imgV.right, imgV.top);
    [dotV.layer setMasksToBounds:YES];
    [dotV.layer setCornerRadius:self.badgeDotWidth * 0.5];
    
    if (dotV.top < 0) {
        dotV.top = 0;
    }
    if (dotV.right < 0) {
        dotV.right = 0;
    }
}

- (void)animateWithImages:(NSArray<UIImage *> *)images duration:(NSTimeInterval)duration {
    if (images == nil || [images isEmpty] || duration == 0) {
        return;
    }
    __weak typeof(self) ws = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __block UIImageView *imgV = nil;
        UIView *container = [ws getContainer];
        for (UIView *sub in container.subviews) {
            NSString *subClassName = NSStringFromClass([sub class]);
            if ([subClassName containsString:@"ImageView"]) {
                imgV = (UIImageView *)sub;
            }
        }
        if (imgV == nil) {
            return;
        }
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            imgV.animationImages = images;
            imgV.animationRepeatCount = 1;
            imgV.animationDuration = duration;
            [imgV startAnimating];
        }];
        [imgV stopAnimating];
        [CATransaction commit];

    });
}

#pragma mark - Load
+ (void)load {
    method_exchangeImplementations(
        class_getInstanceMethod([self class], @selector(setBadgeValue:)),
        class_getInstanceMethod([self class], @selector(_veSetBadgeValue:))
    );
}

- (void)_veSetBadgeValue:(NSString *)badgeValue {
    [self _veSetBadgeValue:badgeValue];
    
    if (self.showBadgeDot == NO) {
        return;
    }
    UIView *dotV = [self getBadgeDotView];
    if (dotV == nil) {
        return;
    }
    dotV.hidden = badgeValue != nil;
}

#pragma mark - Private Get
- (UIView *)getContainer {
    return [self valueForKey:@"_view"];
}

- (UIImageView *)getSwappableView {
    UIImageView *imgV = nil;
    
    UIView *tabBarButton = [self getContainer];
    for (UIView *sub in tabBarButton.subviews) {
        NSString *subClassName = NSStringFromClass([sub class]);
        if ([subClassName containsString:@"ImageView"]) {
            imgV = (UIImageView *)sub;
        }
    }
    if (imgV == nil) {
        // 没设置图片 或者不在选中状态, 检查下 UIVisualEffectContentView
        for (UIView *sub in tabBarButton.subviews) {
            if ([sub isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
                for (UIView *ss in sub.subviews) {
                    if ([ss isKindOfClass:NSClassFromString(@"_UIVisualEffectContentView")]) {
                        for (UIView *lastV in ss.subviews) {
                            NSString *lastClassName = NSStringFromClass([lastV class]);
                            if ([lastClassName containsString:@"ImageView"]) {
                                imgV = (UIImageView *)lastV;
                            }
                        }
                    }
                }
            }
        }
    }
    return imgV;
}

- (UIView *)getBadgeDotView {
    UIView *tabBarButton = [self getContainer];
    UIImageView *imgV = [self getSwappableView];
    if (imgV == nil) {
        return nil;
    }
    UIView *dotV = [tabBarButton viewWithStrTag:@"dot"];
    if (dotV == nil) {
        dotV = [[UIView alloc] init];
        dotV.strTag = @"dot";
        dotV.backgroundColor = self.badgeDotColor;
        dotV.hidden = YES;
        dotV.layer.zPosition = 9999999999999999;
        dotV.userInteractionEnabled = NO;
        [tabBarButton addSubview:dotV];
        [self updateBadgeDotCenter];
    }
    return dotV;
}

@end
