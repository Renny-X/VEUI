//
//  VEPopover.m
//  VEUI
//
//  Created by Coder on 2021/3/8.
//

#import "VEPopover.h"
#import <VEUI/VEUI.h>

@interface VEPopover ()

@property(nonatomic, assign)CGRect fromFrame;
@property(nonatomic, assign)CGRect toFrame;

@property(nonatomic, assign)UIEdgeInsets safeGap;

@end

@implementation VEPopover

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
    } else {
        [self startAnimate:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesHandler)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.contentView];
}

- (void)tapGesHandler {
    if (self.tapToHide) {
        [self hide];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.contentView pointInside:point withEvent:event]) {
        return self.contentView;
    }
    return self.view;
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self startAnimate:YES];
}

#pragma mark - public
- (void)show {
    self.view.backgroundColor = self.coverColor ? : [UIColor colorWithWhite:0 alpha:0.6];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.contentView.frame = self.fromFrame;
    [[UIViewController currentController] presentViewController:self animated:YES completion:nil];
}

- (void)hide {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self startAnimate:NO];
}

- (void)startAnimate:(BOOL)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = show ? self.toFrame : self.fromFrame;
    }];
}

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
        _coverColor = self.view.backgroundColor;
    }
    return _coverColor;
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    self.view.backgroundColor = coverColor;
}

@end
