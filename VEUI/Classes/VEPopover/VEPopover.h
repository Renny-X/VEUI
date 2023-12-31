//
//  VEPopover.h
//  VEUI
//
//  Created by Coder on 2021/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VEPopoverContentAnimationStyle) {
    VEPopoverContentAnimationStyleNone = 0,
    VEPopoverContentAnimationStyleFromTop,
    VEPopoverContentAnimationStyleFromLeft,
    VEPopoverContentAnimationStyleFromBottom,
    VEPopoverContentAnimationStyleFromRight,
};

typedef NS_ENUM(NSInteger, VEPopoverContentPosition) {
    VEPopoverContentPositionCenter = 0,
    VEPopoverContentPositionTop,
    VEPopoverContentPositionLeft,
    VEPopoverContentPositionBottom,
    VEPopoverContentPositionRight,
};

@interface VEPopover : UIViewController

@property(nonatomic, strong)UIColor *coverColor;
@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, assign)UIEdgeInsets edgeInsets;

@property(nonatomic, assign)VEPopoverContentAnimationStyle contentAnimationStyle;
@property(nonatomic, assign)VEPopoverContentPosition contentPosition;

@property(nonatomic, assign)BOOL tapToHide;

- (void)show;

- (void)hide;

/**
 * 显示时动画添加
 */
- (void)withinShowAnimation;
/**
 * 隐藏时动画添加
 */
- (void)withinHideAnimation;

/**
 * 显示动画结束回调
 */
- (void)didEndShowAnimation:(BOOL)finished;
/**
 * 隐藏动画结束回调
 */
- (void)didEndHideAnimation:(BOOL)finished;

@end

NS_ASSUME_NONNULL_END
