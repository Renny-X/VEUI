//
//  VEToast.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/2/20.
//

#import "VEToast.h"
#import "VEToastManager.h"
#import "UIFont+VEUI.h"

@implementation VEToast

+ (void)hide {
    [[VEToastManager manager] hide];
}

+ (void)toastDuration:(CGFloat)duration {
    [VEToastManager manager].duration = duration;
}

// Toast String
+ (void)toast:(NSString *)string {}

+ (void)toast:(NSString *)string duration:(CGFloat)duration {}

// Toast Success
+ (void)success:(NSString *)string {}

+ (void)success:(NSString *)string duration:(CGFloat)duration {}

// Toast Error
+ (void)error:(NSString *)string {}

+ (void)error:(NSString *)string duration:(CGFloat)duration {}

// Toast Custom image string
+ (void)toast:(NSString *)string image:(UIImage *)img {}

+ (void)toast:(NSString *)string image:(UIImage *)img imgSize:(CGSize *)imgSize {}

+ (void)toast:(NSString *)string image:(UIImage *)img duration:(CGFloat)duration {}

+ (void)toast:(NSString *)string image:(UIImage *)img imgSize:(CGSize *)imgSize duration:(CGFloat)duration {}

// Toast Loading
+ (void)loading:(NSString *)string {}

/**
 * @param string toast 文字内容
 * @param mask 是否遮挡操作，Loading默认为true
 */
+ (void)loading:(NSString *)string mask:(BOOL)mask {}

// Toast Custom images Loading
+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images {}

+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images imgSize:(CGSize *)imgSize {}

+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images mask:(BOOL)mask {}

+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images imgSize:(CGSize *)imgSize mask:(BOOL)mask {}

@end
