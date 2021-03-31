//
//  VEToastView.m
//  VEUI
//
//  Created by Coder on 2021/2/22.
//

#import "VEToastView.h"
#import "UIView+VEUI.h"
#import "NSObject+VEUI.h"

#import "VEToastManager.h"

typedef NS_ENUM(NSInteger, VEToastType) {
    VEToastTypeDefault = 0, // 有图有真相
    VEToastTypeIconOnly,
    VEToastTypeStringOnly,
};

@interface VEToastView()

@property(nonatomic, strong)UIView *toastView;

@property(nonatomic, strong)UIView *iconView;
@property(nonatomic, strong)UILabel *textLabel;

@property(nonatomic, assign)VEToastType toastType;
@property(nonatomic, assign)CGSize maxIconSize;
@property(nonatomic, assign)CGFloat verticalPadding;
@property(nonatomic, assign)CGFloat horizontalPadding;
@property(nonatomic, assign)CGFloat textMargin;

@property(nonatomic, assign)CGFloat maxTextWidth;
@property(nonatomic, assign)CGFloat maxToastWidth;

@end

@implementation VEToastView

- (instancetype)initWithView:(UIView *)view string:(NSString *)string {
    if (self = [super init]) {
        self.iconView = view;
        self.textLabel.text = [string isEmpty] ? @"" : string;
        
        self.backgroundColor = UIColor.clearColor;
        self.layer.zPosition = FLT_MAX;
        CGSize tmpLabelSize = [self.textLabel sizeThatFits:CGSizeMake(self.maxTextWidth, 100)];
        self.textLabel.frame = CGRectMake(0, 0, tmpLabelSize.width, tmpLabelSize.height);
        
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
    CGFloat cornerRadius = self.toastType = 12;
    
    switch (self.toastType) {
        case VEToastTypeStringOnly:
            self.toastView.frame = CGRectMake(0, 0, self.textLabel.width + self.horizontalPadding * 2, self.textLabel.height + self.verticalPadding * 2);
            self.textLabel.center = self.toastView.center;
            cornerRadius = 3;
            break;
        case VEToastTypeIconOnly:
            self.toastView.frame = CGRectMake(0, 0, self.iconView.width + self.horizontalPadding * 2, self.iconView.height + self.verticalPadding * 2);
            self.iconView.center = self.toastView.center;
            break;
        default:
            self.toastView.frame = CGRectMake(0, 0, self.maxToastWidth, MAX(self.maxToastWidth, self.verticalPadding * 2 + self.textMargin + self.textLabel.height + self.iconView.height));
            self.iconView.centerX = self.toastView.centerX;
            self.iconView.y = self.verticalPadding;
            
            self.textLabel.centerX = self.toastView.centerX;
            self.textLabel.y = self.iconView.maxY + self.textMargin;
            break;
    }
    self.frame = self.toastView.frame;
    self.center = [UIApplication sharedApplication].keyWindow.center;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.toastView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.toastView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.toastView.layer.mask = maskLayer;
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

- (VEToastType)toastType {
    if (self.iconView && self.textLabel.text.length) {
        return VEToastTypeDefault;
    }
    if (!self.iconView) {
        return VEToastTypeStringOnly;
    }
    return VEToastTypeIconOnly;
}

- (CGFloat)verticalPadding {
    switch (self.toastType) {
        case VEToastTypeStringOnly:
            return 5;
        case VEToastTypeIconOnly:
            return 25;
        default:
            return 30;
    }
}

- (CGFloat)horizontalPadding {
    switch (self.toastType) {
        case VEToastTypeStringOnly:
            return 15;
        case VEToastTypeIconOnly:
            return self.verticalPadding;
        default:
            return 10;
    }
}

- (CGFloat)textMargin {
    return self.toastType == VEToastTypeStringOnly ? 0 : 12;
}

- (CGSize)maxIconSize {
    if (self.toastType == VEToastTypeStringOnly) {
        return CGSizeZero;
    }
    return CGSizeMake(self.maxToastWidth - self.horizontalPadding * 2, self.maxToastWidth - self.horizontalPadding * 2);
}

- (CGFloat)maxTextWidth {
    return self.maxToastWidth - self.horizontalPadding * 2;
}

- (CGFloat)maxToastWidth {
    switch (self.toastType) {
        case VEToastTypeStringOnly:
            return [UIApplication sharedApplication].keyWindow.width - 60;
        case VEToastTypeIconOnly:
            return 145;
        default:
            return 145;
    }
}

#pragma mark - Set
- (void)setIconView:(UIView *)iconView {
    if (!iconView) {
        return;
    }
    _iconView = iconView;
    if (iconView.frame.size.width > self.maxIconSize.width || iconView.frame.size.height > self.maxIconSize.height) {
        CGRect tmpFrame;
        CGFloat scale = iconView.frame.size.width / iconView.frame.size.height;
        if (scale > 1) {
            tmpFrame = CGRectMake(0, 0, self.maxIconSize.width, self.maxIconSize.width / scale);
        } else {
            tmpFrame = CGRectMake(0, 0, self.maxIconSize.height * scale, self.maxIconSize.height);
        }
        _iconView.frame = tmpFrame;
    }
}

@end
