//
//  VESwitch.m
//  TestDemo
//
//  Created by Drake on 2021/2/23.
//

#import "VESwitch.h"
#import <Masonry/Masonry.h>

@interface VESwitch ()
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UISwitch *veSwitch;

@end

@implementation VESwitch

+ (UIColor *)HEX_RGB:(long)hexValue
{
    UIColor *color = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                     green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                      blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0];
    return color;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.clipsToBounds = YES;
        [self setup];
        [self addConstraint];
    }
    return self;
}

- (void)dealloc
{
    _clickBlock = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addConstraint];
}

#pragma mark - public method
- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    [self.veSwitch setOn:on animated:animated];
}

- (void)setOn:(BOOL)on
{
    self.veSwitch.on = on;
}

#pragma mark - private method
- (void)addConstraint
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.veSwitch];
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.veSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}

- (void)setup
{
    self.veSwitch.tintColor = [self.class HEX_RGB:0xEDF0F2];
    self.veSwitch.onTintColor = [self.class HEX_RGB:0x0099FF];
    self.veSwitch.thumbTintColor = [UIColor whiteColor];
}

- (void)switchAction:(UISwitch *)oneSwitch
{
    if (oneSwitch == self.veSwitch) {
        if (_clickBlock) {
            _clickBlock(self.veSwitch.isOn);
        }
    }
}

#pragma mark - property
#pragma mark - view
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _backgroundView;
}

- (UISwitch *)veSwitch
{
    if (!_veSwitch) {
        _veSwitch = ({
            UISwitch *sw = [UISwitch new];
            [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            sw;
        });
    }
    return _veSwitch;
}

@end
