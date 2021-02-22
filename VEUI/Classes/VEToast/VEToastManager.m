//
//  VEToastManager.m
//  VEUI
//
//  Created by Coder on 2021/2/20.
//

#import "VEToastManager.h"

@implementation VEToastManager


static VEToastManager *_instance;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[VEToastManager alloc] init];
            _instance.duration = 1.7;
        }
    });
    return _instance;
}

@end
