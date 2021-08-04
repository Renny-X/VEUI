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
 * 重绘 image 添加边距，返回的图片size 为原size + insets
 */
- (UIImage *)resetWithInsets:(UIEdgeInsets)insets;
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

/**
 * image 添加 高斯模糊 CoreImage
 * @param blurLevel 模糊返回 0 ~ 1
 * @return 返回模糊后的图片
 */
- (UIImage *)gaussianBlurImageWithBlurLevel:(CGFloat)blurLevel;
/**
 * 返回 image 指定像素点的颜色
 * @param point 指定像素点
 * @return 指定像素点的颜色
 */
- (UIColor *)colorAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
