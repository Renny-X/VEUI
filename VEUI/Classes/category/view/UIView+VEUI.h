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
/**
 * 字符串tag，跟tag一样的作用
 */
@property (nonatomic, strong) NSString *__nullable strTag;
/**
 * view 的左上顶点坐标
 */
@property (nonatomic, assign) CGPoint orign;
/**
 * view 的左上顶点 x 坐标
 */
@property (nonatomic, assign) CGFloat orignX;
/**
 * view 的左上顶点 y 坐标
 */
@property (nonatomic, assign) CGFloat orignY;
/**
 * view 的中心点 x 坐标
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 * view 的中心点 y 坐标
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 * view 的大小 size
 */
@property (nonatomic, assign) CGSize  size;
/**
 * view 的宽度 width
 */
@property (nonatomic, assign) CGFloat width;
/**
 * view 的高度 height
 */
@property (nonatomic, assign) CGFloat height;
/**
 * view 的右下顶点 x 坐标
 */
@property (nonatomic, assign) CGFloat maxX;
/**
 * view 的右下顶点 y 坐标
 */
@property (nonatomic, assign) CGFloat maxY;
/**
 * 通过strTag 返回对应的 view
 */
- (nullable UIView *)viewWithStrTag:(nullable NSString *)strTag;

@end

NS_ASSUME_NONNULL_END