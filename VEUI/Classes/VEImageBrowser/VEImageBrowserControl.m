//
//  VEImageBrowserControl.m
//  VEUI
//
//  Created by Coder on 2021/2/26.
//

#import "VEImageBrowserControl.h"
#import "UIColor+VEUI.h"
#import "UIFont+VEUI.h"
#import "UIView+VEUI.h"
#import "NSObject+VEUI.h"

@interface VEImageBrowserControl()

@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIView *bottomView;

@property(nonatomic, strong)CAGradientLayer *topLayer;
@property(nonatomic, strong)CAGradientLayer *bottomLayer;

@property(nonatomic, strong)UIButton *closeBtn;
@property(nonatomic, strong)UIButton *moreBtn;
@property(nonatomic, strong)UIImageView *moreBtnImgV;

@property(nonatomic, assign)CGFloat animateOffset;
@property(nonatomic, assign)NSTimeInterval animateDuration;

@property(nonatomic, assign)CGFloat viewHeight;

@end

@implementation VEImageBrowserControl

#pragma mark - init + UI
- (instancetype)init {
    return [self initWithTintColor:[UIColor whiteColor]];
}

- (instancetype)initWithTintColor:(UIColor *)tintColor {
    return [self initWithTintColor:tintColor coverColor:[UIColor blackColor]];
}

- (instancetype)initWithTintColor:(UIColor *)tintColor coverColor:(UIColor *)coverColor {
    if (self = [super init]) {
        self.tintColor = tintColor;
        self.coverColor = coverColor;
        [self initParams];
        [self setUI];
    }
    return self;
}

- (void)initParams {
    self.animateOffset = 8;
    self.animateDuration = 0.17;
    self.viewHeight = 45;
}

- (void)setUI {
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self.topView addSubview:self.closeBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.moreBtn.hidden = !self.showHeaderRightBtn;
    if (@available(iOS 11.0, *)) {
        self.topView.frame = CGRectMake(0, 0, self.width, self.viewHeight + self.safeAreaInsets.top);
        self.bottomView.frame = CGRectMake(0, 0, self.width, self.viewHeight + self.safeAreaInsets.bottom);
    } else {
        self.topView.frame = CGRectMake(0, 0, self.width, self.viewHeight + 20);
        self.bottomView.frame = CGRectMake(0, 0, self.width, self.viewHeight);
    }
    self.bottomView.maxY = self.height;
    self.topLayer.frame = self.topView.bounds;
    self.bottomLayer.frame = self.bottomView.bounds;
    
    self.closeBtn.size = CGSizeMake(self.viewHeight - 8, self.viewHeight - 8);
    self.closeBtn.maxY = self.topView.height;
    self.closeBtn.x = 10;
    [self.closeBtn.layer setCornerRadius:self.closeBtn.height * 0.5];
    
    self.moreBtn.frame = self.closeBtn.frame;
    self.moreBtn.maxX = self.topView.width - self.closeBtn.x;
    self.moreBtnImgV.center = self.moreBtn.center;
}

#pragma mark - 手势处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.topView.alpha == 0) {
        return nil;
    }
    if (CGRectContainsPoint(self.topView.frame, point)) {
        for (UIView *sub in self.topView.subviews) {
            if (CGRectContainsPoint(sub.frame, point)) {
                return sub;
            }
        }
        return self.topView;
    }
    if (CGRectContainsPoint(self.bottomView.frame, point)) {
        for (UIView *sub in self.bottomView.subviews) {
            if (CGRectContainsPoint(sub.frame, point)) {
                return sub;
            }
        }
        return self.bottomView;
    }
    return nil;
}

#pragma mark - Public Action
- (void)show:(BOOL)show {
    self.userInteractionEnabled = show;
    [UIView animateWithDuration:self.animateDuration animations:^{
        self.topView.alpha = show ? 1 : 0;
        self.bottomView.alpha = show ? 1 : 0;
        if (show) {
            self.topView.y += self.animateOffset;
            self.bottomView.y -= self.animateOffset;
        } else {
            self.topView.y -= self.animateOffset;
            self.bottomView.y += self.animateOffset;
        }
    }];
}

#pragma mark - Btn Action
- (void)btnClicked:(UIButton *)sender {
    VEImageBrowserControlBtnType type = [sender.strTag isEqualToString:@"close"] ? VEImageBrowserControlBtnTypeClose : VEImageBrowserControlBtnTypeMore;
    if ([self.delegate respondsToSelector:@selector(funcBtnClicked:)]) {
        [self.delegate funcBtnClicked:type];
    }
}

#pragma mark - Get
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.viewHeight)];
//        [_topView.layer addSublayer:self.topLayer];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.viewHeight)];
//        [_bottomView.layer addSublayer:self.bottomLayer];
    }
    return _bottomView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [btn setTitle:@"\U0000e901" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont VEFontWithSize:30];
        btn.backgroundColor = UIColor.clearColor;
        [btn.layer setMasksToBounds:YES];
        btn.strTag = @"close";
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        btn.backgroundColor = UIColor.clearColor;
        [btn.layer setMasksToBounds:YES];
        btn.hidden = !self.showHeaderRightBtn;
        [btn addSubview:self.moreBtnImgV];
        btn.strTag = @"more";
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn = btn;
    }
    return _moreBtn;
}

- (UIImageView *)moreBtnImgV {
    if (!_moreBtnImgV) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.backgroundColor = UIColor.clearColor;
        imgV.tintColor = self.tintColor;
    }
    return _moreBtnImgV;
}

- (CAGradientLayer *)topLayer {
    if (!_topLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.colors = @[(__bridge id)self.coverColor.CGColor, (__bridge id)[UIColor clearColor].CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1);
        layer.locations = @[@(0.4f), @1];
        _topLayer = layer;
    }
    return _topLayer;
}

- (CAGradientLayer *)bottomLayer {
    if (!_bottomLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)self.coverColor.CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1);
        layer.locations = @[@0, @(0.6f)];
        _bottomLayer = layer;
    }
    return _bottomLayer;
}

#pragma mark - Set
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor ? tintColor : [UIColor whiteColor];
    self.closeBtn.titleLabel.textColor = tintColor;
    self.closeBtn.backgroundColor = [[tintColor inverseColor] colorWithAlphaComponent:0.2];
    self.moreBtnImgV.tintColor = tintColor;
    self.moreBtn.backgroundColor = [[tintColor inverseColor] colorWithAlphaComponent:0.2];
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor ? coverColor : [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    self.topLayer.colors = @[(__bridge id)coverColor.CGColor, (__bridge id)[UIColor clearColor].CGColor];
    self.bottomLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)coverColor.CGColor];
}

- (void)setShowHeaderRightBtn:(BOOL)showHeaderRightBtn {
    self.moreBtn.hidden = !showHeaderRightBtn;
}

- (void)setHeaderRightBtnImage:(UIImage *)headerRightBtnImage {
    _headerRightBtnImage = [headerRightBtnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - safe area
- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self setNeedsLayout];
}

@end
