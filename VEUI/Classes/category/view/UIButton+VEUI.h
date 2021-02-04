//
//  UIButton+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (VEUI)

/**
 * 设置UIButton 背景色
 */
- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
