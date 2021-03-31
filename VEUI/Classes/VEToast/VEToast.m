//
//  VEToast.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/2/20.
//

#import "VEToast.h"
#import "NSObject+VEUI.h"
#import "UIFont+VEUI.h"
#import "UIIMage+VEUI.h"
#import "VEUIDEVTool.h"

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
+ (void)success:(NSString * _Nullable)string {
    return [VEToast success:string duration:[VEToastManager manager].duration];
}

+ (void)success:(NSString * _Nullable)string duration:(NSTimeInterval)duration {
    VEToastLabel *label = [[VEToastLabel alloc] initWithCode:@"\U0000e919" size:[VEToastManager manager].imgSize];
    return [VEToast toastView:label string:string duration:duration mask:NO];
}

// Toast Error
+ (void)error:(NSString * _Nullable)string {
    return [VEToast error:string duration:[VEToastManager manager].duration];
}

+ (void)error:(NSString * _Nullable)string duration:(NSTimeInterval)duration {
    VEToastLabel *label = [[VEToastLabel alloc] initWithCode:@"\U0000e917" size:[VEToastManager manager].imgSize];
    return [VEToast toastView:label string:string duration:duration mask:NO];
}

// Toast Custom image string
+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img {
    return [VEToast toast:string image:img duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img duration:(NSTimeInterval)duration {
    return [VEToast toast:string image:img imgSize:[VEToastManager manager].imgSize duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img imgSize:(CGSize)imgSize {
    return [VEToast toast:string image:img imgSize:imgSize duration:[VEToastManager manager].duration];
}

+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img imgSize:(CGSize)imgSize duration:(NSTimeInterval)duration {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    imgV.image = img;
    return [VEToast toastView:imgV string:string duration:duration mask:NO];
}

// Toast Loading
+ (void)loading:(NSString * _Nullable)string {
    return [VEToast loading:string mask:YES];
}

/**
 * @param string toast 文字内容
 * @param mask 是否遮挡操作，Loading默认为true
 */
+ (void)loading:(NSString * _Nullable)string mask:(BOOL)mask {
    return [VEToast loading:string images:[VEToastManager manager].loadingImages animateDuration:[VEToastManager manager].loadingImages.count / 12.0 mask:YES];
}

// Toast Custom images Loading
+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration {
    return [VEToast loading:string images:images animateDuration:aDuration imgSize:[VEToastManager manager].imgSize mask:YES];
}

+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration imgSize:(CGSize)imgSize {
    return [VEToast loading:string images:images animateDuration:aDuration imgSize:imgSize mask:YES];
}

+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration mask:(BOOL)mask {
    return [VEToast loading:string images:images animateDuration:aDuration imgSize:[VEToastManager manager].imgSize mask:mask];
}

+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration imgSize:(CGSize)imgSize mask:(BOOL)mask {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.animationImages = images;
    [imgV setAnimationDuration:aDuration];
    [imgV setAnimationRepeatCount:0];
    [imgV startAnimating];
    
    return [VEToast toastView:imgV string:string duration:0 mask:mask];
}

// entry
+ (void)toastView:(UIView * _Nullable)view string:(NSString *)string duration:(NSTimeInterval)duration mask:(BOOL)mask {
    if (!view && [string isEmpty]) {
        return;
    }
    VEToastView *toastV = [[VEToastView alloc] initWithView:view string:string];
    return [[VEToastManager manager] show:toastV duration:duration mask:mask];
}

@end
