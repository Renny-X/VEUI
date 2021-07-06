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
 * 通过view 生成image
 */
+ (UIImage *)imageFromView:(UIView *)view;
/**
 * 通过view 生成image，并指定size
 */
+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size;
/**
 * 通过富文本 生成image，并指定size
 */
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(CGSize)size color:(UIColor*)color;
/**
 * 通过富文本 生成image，并指定size
 */
+ (UIImage*)imageWithAttributedString:(NSAttributedString *)attributedString size:(CGSize)size;
/**
 * 将img.size 重置为 size
 */
- (UIImage *)resetToSize:(CGSize)size;
/**
 * 将img.size 重置为 size，scale为像素密度
 */
- (UIImage *)resetToSize:(CGSize)size withScale:(CGFloat)scale;
/**
 * 将image 旋转指定角度
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
/**
 * image 添加圆角
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

- (UIImage *)resetTintColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
