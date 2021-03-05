//
//  UIViewController+VEUI.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/2/25.
//

#import "UIViewController+VEUI.h"

@implementation UIViewController (VEUI)

+ (UIViewController *)currentController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self _nextController:rootVC];
}

+ (UIViewController *)_nextController:(UIViewController *)next {
    if (next.presentedViewController) {
        return [self _nextController:next.presentedViewController];
    }
    if ([next isKindOfClass:[UITabBarController class]]) {
        return [self _nextController:[(UITabBarController *)next selectedViewController]];
    }
    if ([next isKindOfClass:[UINavigationController class]]) {
        return [self _nextController:[(UINavigationController *)next visibleViewController]];
    }
    return next;
}

@end
