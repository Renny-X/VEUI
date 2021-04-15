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

@end

NS_ASSUME_NONNULL_END
