//
//  VECommonCheckCell.m
//  Vedeng
//
//  Created by Drake on 2020/11/2.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "VECommonCheckCell.h"
#import "VEConstant.h"
#import <Masonry/Masonry.h>

#define kCheckIconNormal   (@"复选框-禁用")
#define kCheckIconSelect   (@"复选框-已选")

#define kNormalFont   ([UIFont systemFontOfSize:14])
#define kSelectFont   ([UIFont boldSystemFontOfSize:14])

#define kNormalColor   ([UIColor blackColor])
#define kSelectColor   (HEX_RGB(0x0099FF))

@interface VECommonCheckCell ()
{
    BOOL _onlyShowSelectedCheckIcon;//只显示选中的图标
}

@property(nonatomic,strong)UILabel *mainLabel;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIImageView *checkIcon;

@end

@implementation VECommonCheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addConstraint];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - public methods
+ (CGFloat)heightForCellData:(NSDictionary *)cellData
{
    return 50;
}

- (void)reloadCellData:(NSString *)cellData
{
    self.mainLabel.text = VE_EMPTYSTRING(cellData);
}

- (void)setChosed:(BOOL)chose
{
    if (chose) {
        self.checkIcon.hidden = NO;
        self.checkIcon.image = [UIImage imageNamed:kCheckIconSelect];
        self.mainLabel.textColor = kSelectColor;
        self.mainLabel.font = kSelectFont;
    } else {
        if (_onlyShowSelectedCheckIcon) {
            self.checkIcon.hidden = YES;
        } else {
            self.checkIcon.hidden = NO;
        }
        self.checkIcon.image = [UIImage imageNamed:kCheckIconNormal];
        self.mainLabel.textColor = kNormalColor;
        self.mainLabel.font = kNormalFont;
    }
}

- (void)setOnlyShowSelectedCheckIcon:(BOOL)showCheckIcon
{
    _onlyShowSelectedCheckIcon = showCheckIcon;
}

- (void)setHideBottomLine:(BOOL)hide
{
    self.line.hidden = hide;
}

#pragma mark - private methods
- (void)addConstraint
{
    [self.contentView addSubview:self.mainLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.checkIcon];
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(17);
        make.centerY.mas_offset(0);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    [self.checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.mas_offset(0);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - view
- (UILabel *)mainLabel
{
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.backgroundColor = [UIColor clearColor];
        _mainLabel.textColor = HEX_RGB(0x000000);
        _mainLabel.font = [UIFont systemFontOfSize:14];
        [_mainLabel sizeToFit];
    }
    return _mainLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEX_RGB(0xEDF0F2);
    }
    return _line;
}

- (UIImageView *)checkIcon
{
    if (!_checkIcon) {
        _checkIcon = [UIImageView new];
        _checkIcon.contentMode = UIViewContentModeScaleToFill;
        _checkIcon.backgroundColor = [UIColor clearColor];
        _checkIcon.image = [UIImage imageNamed:kCheckIconNormal];
    }
    return _checkIcon;
}
@end
