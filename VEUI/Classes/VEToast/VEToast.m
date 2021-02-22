//
//  VEToast.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/2/20.
//

#import "VEToast.h"
#import "NSObject+VEUI.h"
#import "UIFont+VEUI.h"

#import "VEToastManager.h"
#import "VEToastLabel.h"
#import "VEToastView.h"

@implementation VEToast

+ (void)hide {
    [[VEToastManager manager] hide];
}

+ (void)toastDuration:(NSTimeInterval)duration {
    [VEToastManager manager].duration = duration;
}

// Toast String
+ (void)toast:(NSString *)string {
    return [VEToast toast:string duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString *)string duration:(NSTimeInterval)duration {
    return [VEToast toastView:nil string:string duration:duration mask:NO];
}

// Toast Success
+ (void)success:(NSString *)string {
    return [VEToast success:string duration:[VEToastManager manager].duration];
}

+ (void)success:(NSString *)string duration:(NSTimeInterval)duration {
    VEToastLabel *label = [[VEToastLabel alloc] initWithCode:@"\U0000e919" size:[VEToastManager manager].imgSize];
    return [VEToast toastView:label string:string duration:duration mask:NO];
}

// Toast Error
+ (void)error:(NSString *)string {
    return [VEToast error:string duration:[VEToastManager manager].duration];
}

+ (void)error:(NSString *)string duration:(NSTimeInterval)duration {
    VEToastLabel *label = [[VEToastLabel alloc] initWithCode:@"\U0000e917" size:[VEToastManager manager].imgSize];
    return [VEToast toastView:label string:string duration:duration mask:NO];
}

// Toast Custom image string
+ (void)toast:(NSString *)string image:(UIImage *)img {
    return [VEToast toast:string image:img duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString *)string image:(UIImage *)img duration:(NSTimeInterval)duration {
    return [VEToast toast:string image:img imgSize:[VEToastManager manager].imgSize duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString *)string image:(UIImage *)img imgSize:(CGSize)imgSize {
    return [VEToast toast:string image:img imgSize:imgSize duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString *)string image:(UIImage *)img imgSize:(CGSize)imgSize duration:(NSTimeInterval)duration {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    imgV.image = img;
    return [VEToast toastView:imgV string:string duration:duration mask:NO];
}

// Toast Loading
+ (void)loading:(NSString *)string {
    return [VEToast loading:string mask:YES];
}

/**
 * @param string toast 文字内容
 * @param mask 是否遮挡操作，Loading默认为true
 */
+ (void)loading:(NSString *)string mask:(BOOL)mask {}

// Toast Custom images Loading
+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images {}

+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images imgSize:(CGSize)imgSize {}

+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images mask:(BOOL)mask {}

+ (void)loading:(NSString *)string images:(NSArray<UIImage *> *)images imgSize:(CGSize)imgSize mask:(BOOL)mask {}

// entry
+ (void)toastView:(UIView * _Nullable)view string:(NSString *)string duration:(NSTimeInterval)duration mask:(BOOL)mask {
    if (!view && [string isEmpty]) {
        return;
    }
    VEToastView *toastV = [[VEToastView alloc] initWithView:view string:string mask:mask];
    return [[VEToastManager manager] show:toastV duration:duration];
}

@end
