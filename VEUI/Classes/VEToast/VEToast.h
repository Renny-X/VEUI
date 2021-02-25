//
//  VEToast.h
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEToast : NSObject

+ (void)hide;

+ (void)toastDuration:(NSTimeInterval)duration;

// Toast String
+ (void)toast:(NSString *)string;

+ (void)toast:(NSString *)string duration:(NSTimeInterval)duration;

// Toast Success
+ (void)success:(NSString * _Nullable)string;

+ (void)success:(NSString * _Nullable)string duration:(NSTimeInterval)duration;

// Toast Error
+ (void)error:(NSString * _Nullable)string;

+ (void)error:(NSString * _Nullable)string duration:(NSTimeInterval)duration;

// Toast Custom image string
+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img;

+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img imgSize:(CGSize)imgSize;

+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img duration:(NSTimeInterval)duration;

+ (void)toast:(NSString * _Nullable)string image:(UIImage *)img imgSize:(CGSize)imgSize duration:(NSTimeInterval)duration;

// Toast Loading
+ (void)loading:(NSString * _Nullable)string;

/**
 * @param string toast 文字内容
 * @param mask 是否遮挡操作，Loading默认为true
 */
+ (void)loading:(NSString * _Nullable)string mask:(BOOL)mask;

// Toast Custom images Loading
+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration;

+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration imgSize:(CGSize)imgSize;

+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration mask:(BOOL)mask;

+ (void)loading:(NSString * _Nullable)string images:(NSArray<UIImage *> *)images animateDuration:(NSTimeInterval)aDuration imgSize:(CGSize)imgSize mask:(BOOL)mask;

// entry
+ (void)toastView:(UIView * _Nullable)view string:(NSString *)string duration:(NSTimeInterval)duration mask:(BOOL)mask;

@end

NS_ASSUME_NONNULL_END
