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

/**
 * Hex 字符串 转 UIColor，支持3、4、6、8位 Hex
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

- (UIColor *)colorWithAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
