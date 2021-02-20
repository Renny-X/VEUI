//
//  VESearckKeyView.m
//  Vedeng
//
//  Created by Drake on 2020/10/30.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "VETagDisplayComponent.h"
#import <Masonry/Masonry.h>
#import "VEConstant.h"

typedef void(^ButtonClickBlock)(void);//点击
typedef void(^ButtonCloseBlock)(void);//关闭

@interface  VEKeywordItem()
@property(nonatomic,strong)UIColor              *textColor;//按钮的文字颜色  ⚠️这可以设置不同按钮 不同颜色
@property(nonatomic,strong)UIColor              *borderColor;//按钮的边框颜色 ⚠️这可以设置不同按钮 不同边框颜色
@end

@implementation VEKeywordItem

- (instancetype)copyModel
{
    VEKeywordItem *objct = [VEKeywordItem new];
    objct.text          = self.text.mutableCopy;
    objct.textColor     = self.textColor;
    objct.borderColor   = self.borderColor;
    objct.state         = self.state;
    return objct;
}

- (void)setState:(VEKeywordButtonState)state
{
    _state = state;
    if (state == StateNormal) {
        
    } else if (state == StateShowCheck) {
        
    } else if (state == StateShowClose) {
        
    }
}

@end

#pragma mark - 关键词 按钮
@interface  VEKeyButton: UIView

@property(nonatomic,strong) UILabel                         *textLabel;
@property (nonatomic,strong) UIButton                       *closeButton;
@property (nonatomic,strong) UILabel                        *checkIcon;
@property (nonatomic,copy) ButtonClickBlock                 clickBlock;
@property (nonatomic,copy) ButtonCloseBlock                 closeBlock;
@property (nonatomic,assign) VEKeywordButtonState           state;
@property (nonatomic,assign) VEKeywordItem                  *model;

- (void)reloadButton:(VEKeywordItem *)data;

- (void)setLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

@end

@implementation VEKeyButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addConstraint];
        self.layer.borderColor = [UIColor clearColor].CGColor;//默认没有边框
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        _state = StateNormal;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textLabelAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc
{
    _clickBlock = nil;
    _closeBlock = nil;
}

#pragma mark - private
- (void)addConstraint
{
    [self addSubview:self.textLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.checkIcon];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(-10);
        make.centerY.mas_offset(0);
    }];
    [self.checkIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.mas_equalTo(0);
        make.bottom.mas_offset(0);
    }];
}

- (void)textLabelAction
{
    if (_clickBlock) {
        _clickBlock();
    }
}

- (void)closeAction:(UIButton *)button
{
    if (_closeBlock) {
        _closeBlock();
    }
}

#pragma mark - public
- (void)reloadButton:(VEKeywordItem *)data
{
    self.model = data;
    self.textLabel.textColor = self.model.textColor;
    self.textLabel.text = self.model.text;
    self.layer.borderColor = self.model.borderColor.CGColor;
    
    if (self.model.state == StateNormal) {//普通状态
        self.checkIcon.hidden = YES;
        self.closeButton.hidden = YES;
    } else if (self.model.state == StateShowClose) {//显示叉号
        self.checkIcon.hidden = YES;
        self.closeButton.hidden = NO;
    } else if (self.model.state == StateShowCheck) {//显示勾√
        self.checkIcon.hidden = NO;
        self.closeButton.hidden = YES;
    }
}

- (void)setLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin
{
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargin);
        make.right.mas_equalTo(-rightMargin);
        make.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark - view
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setTitle:@"\U0000e901" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont fontWithName:@"HC" size:16];
        [_closeButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(closeAction:)
               forControlEvents:UIControlEventTouchUpInside];
        _closeButton.hidden = YES;
    }
    return _closeButton;
}

- (UILabel *)checkIcon
{
    if (!_checkIcon) {
        _checkIcon = [UILabel new];
        _checkIcon.text = @"\U0000e93d";
        _checkIcon.font = [UIFont fontWithName:@"HC" size:16];
        _checkIcon.textColor = HEX_RGB(0xFF9900);
        _checkIcon.hidden = YES;
    }
    return _checkIcon;
}

@end



#pragma mark - <通用的> 关键词 展示通用组件

@interface VETagDisplayComponent ()

@property(nonatomic,strong)NSMutableArray       *itemFrameArray;
@property(nonatomic,assign)CGFloat              totalWidth;

@end

@implementation VETagDisplayComponent

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        _totalHeight = 0;
        self.totalWidth = CGRectGetWidth(frame);
        
        self.itemTextFont = [UIFont systemFontOfSize:12];
        self.itemBgColor = [UIColor whiteColor];//背景色默认白色
        self.itemTextLeftPadding = 15;
        self.itemTextRightPadding = 15;
        self.itemVerticalSpace = 10;
        self.itemHorizontalSpace = 10;
        self.itemHeight = 28;
        self.containerEdgeSpace = 0;
        
        self.itemTextColorOnNormal = HEX_RGB(0x000000);
        self.itemBorderColorOnNormal = [UIColor clearColor];//默认没有边框
        self.itemTextColorOnHighlight = HEX_RGB(0xFF9900);
        self.itemBorderColorOnHighlight = HEX_RGB(0xFF9900);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (CGRectGetWidth(self.frame)) {
        if (self.totalWidth != (int)CGRectGetWidth(self.frame)) {
            self.totalWidth = CGRectGetWidth(self.frame);
            [self configTags];
            [self reloadInterface];
        }
    }
}

- (void)dealloc
{
    _itemClickBlock = nil;
    _itemCloseBlock = nil;
    _getHeightBlock = nil;
}

#pragma mark - private
-(void)setKeyModelArray:(NSArray<VEKeywordItem *> *)keyModelArray
{
    if (![_keyModelArray isEqual:keyModelArray]) {
        _keyModelArray = nil;
        _keyModelArray = keyModelArray;
    }
    [self configTags];
    [self reloadInterface];
}

-(void)configTags
{
    CGFloat orignHMargin = self.containerEdgeSpace;
    CGFloat orignVerMargin = 0;
    CGFloat buttonHeight = self.itemHeight;
    
    _totalHeight = 0;
    
    [self.itemFrameArray removeAllObjects];
    
    if (self.totalWidth <= 0) {
        return;
    }
    
    for (int index = 0; index < self.keyModelArray.count; index++) {
        
        VEKeywordItem *keyModel = VD_SafeObjectAtIndex(self.keyModelArray, index);
        
        CGFloat buttonWidth = [self size4String:keyModel.text
                                       withFont:self.itemTextFont
                                    boundHeight:buttonHeight].width;
        buttonWidth += self.itemTextLeftPadding + self.itemTextRightPadding;
        buttonWidth = ceil(buttonWidth);
        
        if (buttonWidth + self.containerEdgeSpace*2 >= self.totalWidth) {
            buttonWidth = self.totalWidth - 2*self.containerEdgeSpace;
        }
        if (orignHMargin + buttonWidth + self.containerEdgeSpace > self.totalWidth) {
            orignVerMargin = orignVerMargin + buttonHeight + self.itemVerticalSpace;
            orignHMargin = self.containerEdgeSpace;
        }
        
        CGRect frame= CGRectMake(floor(orignHMargin), floor(orignVerMargin), floor(buttonWidth), floor(buttonHeight));
        [self.itemFrameArray addObject:NSStringFromCGRect(frame)];
        
        if (index == self.keyModelArray.count - 1) {
            _totalHeight = orignVerMargin + buttonHeight + self.itemVerticalSpace;
        }
        if (self.totalHeight > self.itemHeight) {
            _totalHeight -= self.itemVerticalSpace;
        }
        orignHMargin = orignHMargin + buttonWidth + self.itemHorizontalSpace;
    }
    _totalHeight = ceil(_totalHeight);
    if (_getHeightBlock) {
        _getHeightBlock(self.totalHeight);
    }
}

-(CGSize)size4String:(NSString *)string
            withFont:(UIFont *)font
         boundHeight:(CGFloat)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

-(void)reloadInterface
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[VEKeyButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    for (int index = 0; index < self.itemFrameArray.count; index++) {
        
        CGRect frame = CGRectFromString(VD_SafeObjectAtIndex(self.itemFrameArray, index));
        
        VEKeyButton *button = [VEKeyButton new];
        button.textLabel.font = self.itemTextFont;
        
        VEKeywordItem *model = VD_SafeObjectAtIndex(self.keyModelArray, index);
        
        if (model.state == StateNormal) {
            model.textColor = self.itemTextColorOnNormal;
            model.borderColor = self.itemBorderColorOnNormal;
        } else if (model.state == StateShowClose || model.state == StateShowCheck) {
            model.textColor = self.itemTextColorOnHighlight;
            model.borderColor = self.itemBorderColorOnHighlight;
        }
        
        [button setLeftMargin:self.itemTextLeftPadding rightMargin:self.itemTextRightPadding];
        [button reloadButton:model];
        button.backgroundColor = self.itemBgColor;
        VD_WS(ws);
        button.clickBlock = ^{
            if (ws.itemClickBlock) {
                ws.itemClickBlock(index);
            }
        };
        button.closeBlock = ^{
            if (ws.itemCloseBlock) {
                ws.itemCloseBlock(index);
            }
        };
        button.frame = frame;
        [self addSubview:button];
    }
}

-(void)itemButtonClick:(UIButton *)button
{
    if (_itemClickBlock) {
        _itemClickBlock(button.tag-200);
    }
}

-(NSMutableArray *)itemFrameArray
{
    if (!_itemFrameArray) {
        _itemFrameArray = [NSMutableArray array];
    }
    return _itemFrameArray;
}

@end
