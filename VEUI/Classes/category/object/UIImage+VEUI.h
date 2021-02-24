//
//  UIImage+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (VEUI)

/**
 * 将img.size 重置为 size
 */
+ (UIImage *)image:(UIImage *)img resetToSize:(CGSize)size;
/**
 * 返回底色为color 的图片，大小为 (width: 1, height: 1)
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 * 返回底色为color 的图片，大小为size
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 * 通过url 获取Image
 */
+ (UIImage *)imageWithURL:(NSString *)url;
/**
 * 将img.size 重置为 size
 */
- (UIImage *)resetToSize:(CGSize)size;
/**
 * 将img.size 重置为 size，scale为像素密度
 */
- (UIImage *)resetToSize:(CGSize)size withScale:(CGFloat)scale;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end

NS_ASSUME_NONNULL_END
