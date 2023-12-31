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
 * view 的左上顶点坐标
 */
@property (nonatomic, assign) CGPoint orign;
/**
 * view 的左上顶点 x 坐标
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat left;
/**
 * view 的左上顶点 y 坐标
 */
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat top;
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
@property (nonatomic, assign) CGSize size;
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
@property (nonatomic, assign) CGFloat right;
/**
 * view 的右下顶点 y 坐标
 */
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat bottom;
/**
 * viewController 当前view所在的controller
 */
- (UIViewController *)viewController;
/**
 * concat 复制当前view并返回
 */
- (id)concat;
/**
 * 通过strTag 返回对应的 view
 */
- (nullable UIView *)viewWithStrTag:(nullable NSString *)strTag;
/**
 * 移除当前view 所有subview
 */
- (void)removeAllSubviews;
/**
 * 将当前view 添加到superView
 */
- (void)addToSuperView:(UIView *)superView;
/**
 * 添加全部圆角
 */
- (void)addCornerRadius:(CGFloat)radius;
/**
 * 添加圆角 到指定corner
 */
- (void)addCornerRadius:(CGFloat)radius toCorners:(UIRectCorner)corners;

@end

@interface VECornerRadiusModel : NSObject

@property(nonatomic, assign)CGFloat radius;
@property(nonatomic, assign)UIRectCorner corners;

@end

NS_ASSUME_NONNULL_END
