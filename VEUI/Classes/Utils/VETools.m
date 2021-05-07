//
//  VETools.m
//  VEUI
//
//  Created by Coder on 2021/3/23.
//

#import "VETools.h"

int randomNum(int from, int to) {
    if (to < from) {
        return 0;
    }
    return rand() % (to - from + 1) + from;
}

BOOL NSRangeContainRange(NSRange range, NSRange subRange) {
    if (subRange.location < range.location) {
        return false;
    }
    if (subRange.location + subRange.length > range.location + range.length) {
        return false;
    }
    return true;
}

@implementation VETools

+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    }
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
