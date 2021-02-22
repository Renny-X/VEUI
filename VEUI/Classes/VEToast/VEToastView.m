//
//  VEToastView.m
//  VEUI
//
//  Created by Coder on 2021/2/22.
//

#import "VEToastView.h"
#import "UIView+VEUI.h"

#import "VEToastManager.h"

@interface VEToastView()

@property(nonatomic, strong)UIView *maskView;
@property(nonatomic, strong)UIView *iconView;
@property(nonatomic, strong)UIView *toastView;
@property(nonatomic, strong)UILabel *textLabel;
@property(nonatomic, assign)BOOL mask;

@property(nonatomic, assign)BOOL onlyString;
@property(nonatomic, assign)CGSize maxIconSize;
@property(nonatomic, assign)CGFloat verticalPadding;
@property(nonatomic, assign)CGFloat horizontalPadding;
@property(nonatomic, assign)CGFloat textMargin;

@property(nonatomic, assign)CGFloat maxWidth;

@end

@implementation VEToastView

- (instancetype)initWithView:(UIView *)view string:(NSString *)string mask:(BOOL)mask {
    if (self = [super init]) {
        self.maxIconSize = CGSizeMake(120, 120);
        self.mask = mask;
        self.iconView = view;
        self.textLabel.text = string;
        
        self.backgroundColor = UIColor.clearColor;
        self.layer.zPosition = FLT_MAX;
        [self addSubview:self.maskView];
        CGSize tmpLabelSize = [self.textLabel sizeThatFits:CGSizeMake(self.maxWidth, 100)];
        self.textLabel.frame = CGRectMake(0, 0, tmpLabelSize.width, tmpLabelSize.height);
        
        [self.toastView.layer setMasksToBounds:YES];
        [self.toastView.layer setCornerRadius:self.onlyString ? 3 : 12];
        [self addSubview:self.toastView];
        
        if (self.iconView) {
            [self.toastView addSubview:self.iconView];
        }
        [self.toastView addSubview:self.textLabel];
        [self layout];
    }
    return self;
}

- (void)layout {
    if (self.onlyString) {
        self.toastView.frame = CGRectMake(0, 0, self.textLabel.width + self.horizontalPadding * 2, self.textLabel.height + self.verticalPadding * 2);
        self.textLabel.center = self.toastView.center;
    } else {
        self.toastView.frame = CGRectMake(0, 0, 150, MAX(100, self.verticalPadding * 2 + self.textMargin + self.textLabel.height + self.iconView.height));
        self.iconView.centerX = self.toastView.centerX;
        self.iconView.orignY = self.verticalPadding;
        
        self.textLabel.centerX = self.toastView.centerX;
        self.textLabel.orignY = self.iconView.maxY + self.textMargin;
    }
    
    if (self.mask) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.toastView.center = self.center;
        self.maskView.frame = self.frame;
    } else {
        self.frame = self.toastView.frame;
        self.center = [UIApplication sharedApplication].keyWindow.center;
        [self.maskView removeFromSuperview];
    }
}

#pragma mark - Get
- (UIView *)toastView {
    if (!_toastView) {
        _toastView = [[UIView alloc] init];
        _toastView.backgroundColor = [VEToastManager manager].toastColor;
    }
    return _toastView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:[VEToastManager manager].textFont];
        _textLabel.textColor = [VEToastManager manager].tintColor;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 2;
    }
    return _textLabel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _maskView;
}

- (BOOL)onlyString {
    return !self.iconView;
}

- (CGFloat)verticalPadding {
    return self.onlyString ? 5 : 30;
}

- (CGFloat)horizontalPadding {
    return self.onlyString ? 15 : 0;
}

- (CGFloat)textMargin {
    return self.onlyString ? 0 : 12;
}

- (CGFloat)maxWidth {
    return self.onlyString ? [UIApplication sharedApplication].keyWindow.width - 60 - self.horizontalPadding * 2 : 135;
}

#pragma mark - Set
- (void)setIconView:(UIView *)iconView {
    if (!iconView) {
        return;
    }
    if (iconView.frame.size.width > self.maxIconSize.width || iconView.frame.size.height > self.maxIconSize.height) {
        CGRect tmpFrame;
        CGFloat scale = iconView.frame.size.width / iconView.frame.size.height;
        if (scale > 1) {
            tmpFrame = CGRectMake(0, 0, self.maxIconSize.width, self.maxIconSize.width / scale);
        } else {
            tmpFrame = CGRectMake(0, 0, self.maxIconSize.height * scale, self.maxIconSize.height);
        }
        iconView.frame = tmpFrame;
    }
    _iconView = iconView;
}

@end
