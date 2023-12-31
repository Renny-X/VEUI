//
//  VEPopover.m
//  VEUI
//
//  Created by Coder on 2021/3/8.
//

#import "VEPopover.h"
#import <VEUI/VEUI.h>

@interface VEPopover ()

@property(nonatomic, strong)UIColor *toColor;

@property(nonatomic, assign)CGRect fromFrame;
@property(nonatomic, assign)CGRect toFrame;

@property(nonatomic, assign)UIEdgeInsets safeGap;

@end

@implementation VEPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.view && self.tapToHide) {
        [self hide];
    }
}

#pragma mark - public
- (void)show {
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.contentView.frame = self.fromFrame;
    
    __weak typeof(self) ws = self;
    [[UIViewController currentController] presentViewController:self animated:NO completion:^{
        [ws startAnimate:YES];
    }];
}

- (void)hide {
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self startAnimate:NO];
}

- (void)startAnimate:(BOOL)show {
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 animations:^{
        ws.view.backgroundColor = ws.coverColor;
        ws.contentView.frame = show ? ws.toFrame : ws.fromFrame;
        if (show) {
            if ([ws respondsToSelector:@selector(withinShowAnimation)]) {
                [ws withinShowAnimation];
            }
        } else {
            if ([ws respondsToSelector:@selector(withinHideAnimation)]) {
                [ws withinHideAnimation];
            }
        }
    } completion:^(BOOL finished) {
        if (show) {
            if ([ws respondsToSelector:@selector(didEndShowAnimation:)]) {
                [ws didEndShowAnimation:finished];
            }
        } else {
            if ([ws respondsToSelector:@selector(didEndHideAnimation:)]) {
                [ws didEndHideAnimation:finished];
            }
        }
    }];
}

- (void)withinShowAnimation {}

- (void)withinHideAnimation {}

- (void)withinShowAnimation:(BOOL)finished {}

- (void)withinHideAnimation:(BOOL)finished {}

#pragma mark - Get
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (CGRect)fromFrame {
    UIView *tmpView = [[UIView alloc] initWithFrame:self.toFrame];
    switch (self.contentAnimationStyle) {
        case VEPopoverContentAnimationStyleFromTop:
            tmpView.maxY = -100;
            break;
        case VEPopoverContentAnimationStyleFromLeft:
            tmpView.maxX = -100;
            break;
        case VEPopoverContentAnimationStyleFromBottom:
            tmpView.y = self.view.height + 100;
            break;
        case VEPopoverContentAnimationStyleFromRight:
            tmpView.x = self.view.width + 100;
            break;
        default:
            break;
    }
    return tmpView.frame;
}

- (CGRect)toFrame {
    UIView *tmpView = [[UIView alloc] initWithFrame:self.contentView.frame];
    tmpView.center = self.view.center;
    switch (self.contentPosition) {
        case VEPopoverContentPositionTop:
            tmpView.y = self.safeGap.top + self.edgeInsets.top;
            break;
        case VEPopoverContentPositionLeft:
            tmpView.x = self.edgeInsets.left;
            break;
        case VEPopoverContentPositionBottom:
            tmpView.maxY = self.view.height - self.safeGap.bottom - self.edgeInsets.bottom;
            break;
        case VEPopoverContentPositionRight:
            tmpView.maxX = self.view.width - self.edgeInsets.right;
            break;
        default:
            tmpView.center = self.view.center;
            break;
    }
    return tmpView.frame;
}

- (UIEdgeInsets)safeGap {
    if (@available(iOS 11.0, *)) {
        return UIEdgeInsetsMake(self.view.safeAreaInsets.top, 0, self.view.safeAreaInsets.bottom, 0);
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

#pragma mark - Cover Color
@synthesize coverColor = _coverColor;
- (UIColor *)coverColor {
    if (!_coverColor) {
        _coverColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _coverColor;
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
}

@end
