//
//  VETipView.h
//  Store
//
//  Created by Coder on 2021/1/6.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEBubbleView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VETipContentPosition) {
    VETipContentPositionUnknown = 0, // 未知状态 计算下
    VETipContentPositionTop, // 内容区域在上面 箭头在下面
    VETipContentPositionRight,
    VETipContentPositionBottom,
    VETipContentPositionLeft,
};

typedef NS_ENUM(NSInteger, VETipDirection) {
    VETipDirectionAuto = 0, // 自适应 内容位置优先级 上 右 下 左
    VETipDirectionVertical, // 垂直方向 内容位置优先级 上 下
    VETipDirectionHorizontal, // 水平方向 内容位置优先级 右 <[] 左 []>
};

@interface VETipView : UIView

@property(nonatomic, strong)VEBubbleView *bubble;

/**
 * contentSize: 内容区域大小
 */
@property(nonatomic, assign)CGSize contentSize;

/**
 * focusView: tipView关联的View
 */
@property(nonatomic, strong)UIView *focusView;

/**
 * containerView: tipView适配的View，默认为keyWindow
 */
@property(nonatomic, strong)UIView *containerView;

/**
 * direction: 内容方向
 */
@property(nonatomic, assign)VETipDirection direction;

/**
 * arrowPosition:   内容位置 默认优先级 上 右 下 左
 */
@property(nonatomic, assign)VETipContentPosition contentPosition;

/**
 * contentGap:     content位置相对focusView距离
 */
@property(nonatomic, assign)CGFloat contentGap;

- (instancetype)initWithFocusView:(UIView * _Nonnull)focusView
                      contentSize:(CGSize)contentSize;

- (instancetype)initWithFocusView:(UIView * _Nonnull)focusView
                      contentSize:(CGSize)contentSize
                        direction:(VETipDirection)direction;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
