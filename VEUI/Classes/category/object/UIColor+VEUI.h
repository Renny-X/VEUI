//
//  UIColor+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (VEUI)

@property(nonatomic, strong, readonly)UIColor *inverseColor;

@property(nonatomic, assign, readonly)CGFloat alpha;

/**
 * Hex 字符串 转 UIColor，支持3、4、6、8位 Hex
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

// 获取两个颜色的中间颜色
+ (UIColor *)colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;

+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
