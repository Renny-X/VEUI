//
//  UIView+VEUI.h
//  Store
//
//  Created by Coder on 2021/1/12.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VEUI)
/**
 * viewController 当前view所在的controller
 */
- (UIViewController *)viewController;
/**
 * concat 复制当前view并返回
 */
- (id)concat;

@end

NS_ASSUME_NONNULL_END
