//
//  VEUIDEVTool.m
//  VEUI
//
//  Created by Coder on 2021/2/23.
//

#import "VEUIDEVTool.h"

@implementation VEUIDEVTool

+ (NSBundle *)vebundle {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"VEUI" withExtension:@"bundle"];
    if (!bundleUrl) {
        bundleUrl = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        bundleUrl = [bundleUrl URLByAppendingPathComponent:@"VEUI.framework"];
        bundleUrl = [bundleUrl URLByAppendingPathComponent:@"VEUI.bundle"];
    }
    if (bundleUrl) {
        bundle = [NSBundle bundleWithURL:bundleUrl];
    }
    return bundle;
}

@end
