//
//  VETools.m
//  VEUI
//
//  Created by Coder on 2021/3/23.
//

#import "VETools.h"

@implementation VETools

+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    }
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
