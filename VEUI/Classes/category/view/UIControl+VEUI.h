//
//  UIControl+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (VEUI)

/**
 *  扩大按钮的点击范围（insets必须不超过button的superview范围,否者超出范围的不起作用）
 */
@property(nonatomic, assign) UIEdgeInsets hitEdgeInsets;

@end

NS_ASSUME_NONNULL_END
