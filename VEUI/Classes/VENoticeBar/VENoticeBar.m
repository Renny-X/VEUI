//
//  VENoticeBar.m
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import "VENoticeBar.h"
#import <VEUI/VEUI.h>

@interface VENoticeBar ()

@property(nonatomic, strong)UILabel *infoLabel;

@property(nonatomic, strong)UILabel *icon;
@property(nonatomic, strong)UIButton *close;
@property(nonatomic, strong)UIButton *moreBtn;

@property(nonatomic, assign)CGFloat btnWidth;

@end

@implementation VENoticeBar

#pragma mark - Layout
- (void)layoutWithWidth:(CGFloat)width {
    if (self.iconString && self.iconString.length) {
        self.icon.text = self.iconString;
    }
    float horizontalGap = 5;
    float gap = 10;
    if (self.style == VENoticeBarStyleText) {
        self.icon.frame = CGRectMake(horizontalGap, 10, 0, 20);
        self.close.frame = CGRectMake(width - horizontalGap, 0, 0, 20);
        self.moreBtn.frame = CGRectMake(self.close.x, 0, 0, 20);
    } else {
        self.icon.orign = CGPointMake(horizontalGap + gap, 10);
        if (self.iconIsHidden) {
            self.icon.width = 0;
        }
        if (self.closeIsHidden) {
            self.close.width = 0;
        }
        self.close.maxX = width - horizontalGap;
        
        self.moreBtn.width = self.btnTitle.length ? self.btnWidth : 0;
        self.moreBtn.maxX = self.close.x;
    }
    float left = self.icon.maxX + gap;
    float wd = self.moreBtn.x - left - gap;
    CGSize tmpSize = [self.infoLabel sizeThatFits:CGSizeMake(wd, 30)];
    self.infoLabel.frame = CGRectMake(left, 12, wd, tmpSize.height);
    float height = self.infoLabel.height + self.infoLabel.y * 2;
//    if (height < 42) {
//        height = 42;
//    }
    self.size = CGSizeMake(width, height);
    self.moreBtn.centerY = self.height * 0.5;
    self.close.height = self.height - 23;
    self.close.centerY = self.moreBtn.centerY;
}

- (void)btnClicked:(UIButton *)sender {
    if (sender.tag == 1001 && self.onCloseClicked) {
        self.onCloseClicked();
    }
    if (sender.tag == 1002) {
        if (self.onBtnClicked) {
            self.onBtnClicked();
        } else {
            [self hide];
        }
    }
}

- (void)show {
    if (!self.superview) {
        return;
    }
    float width = self.width;
    if (!width) {
        width = self.width;
    }
    [self layoutWithWidth:width];
    if (self.superview) {
        [self.superview setNeedsLayout];
    }
}

- (void)hide {
    self.height = 0;
    if (self.superview) {
        [self.superview setNeedsLayout];
    }
}

#pragma mark - INIT
- (instancetype)init {
    if (self = [super init]) {
        self.style = VENoticeBarStyleText;
        self.btnTitle = @"";
        self.infoLines = 0;
        self.btnWidth = 45;
        [self addSubview:self.icon];
        [self addSubview:self.infoLabel];
        [self addSubview:self.moreBtn];
        [self addSubview:self.close];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithStyle:(VENoticeBarStyle)style {
    self = [self init];
    self.style = style;
    return self;
}
- (instancetype)initWithStyle:(VENoticeBarStyle)style info:(NSString *)info {
    self = [self initWithStyle:style];
    self.info = info;
    return self;
}
- (instancetype)initWithStyle:(VENoticeBarStyle)style info:(NSString *)info btnTitle:(NSString *)btnTitle {
    self = [self initWithStyle:style info:info];
    self.btnTitle = btnTitle;
    return self;
}

#pragma mark - Get
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.numberOfLines = self.infoLines;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _infoLabel;
}

- (UILabel *)icon {
    if (!_icon) {
        _icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _icon.font = [UIFont VEFontWithSize:18];
        _icon.textAlignment = NSTextAlignmentCenter;
        _icon.adjustsFontSizeToFitWidth = YES;
    }
    return _icon;
}

- (UIButton *)close {
    if (!_close) {
        _close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _close.titleLabel.font = [UIFont VEFontWithSize:16];
        _close.titleLabel.adjustsFontSizeToFitWidth = YES;
        _close.tag = 1001;
        [_close setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_close setTitle:@"\U0000e901" forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _close;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 23)];
        _moreBtn.tag = 1002;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setBackgroundColor:[UIColor whiteColor]];
        [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_moreBtn.layer setMasksToBounds:YES];
        [_moreBtn.layer setCornerRadius:3];
        [_moreBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

#pragma mark - Set
- (void)setStyle:(VENoticeBarStyle)style {
    _style = style;
    /**
     * bgColor: 背景色
     * VENoticeBarStyleText:        #FFEACC
     * VENoticeBarStyleInfo:        #CCE5FF ==> #0099FF
     * VENoticeBarStyleWarning: #FFEECC ==> #FF9900
     * VENoticeBarStyleSuccess: #DDFFCC ==> #00CC00
     */
    switch (style) {
        case VENoticeBarStyleInfo:
            self.bgColor = [UIColor colorWithHexString:@"#CCE5FF"];
            self.infoColor = [UIColor colorWithWhite:0 alpha:1];
            self.iconIsHidden = NO;
            self.icon.text = @"\U0000e91e";
            self.icon.textColor = [UIColor colorWithHexString:@"#0099FF"];
            break;
        case VENoticeBarStyleWarning:
            self.bgColor = [UIColor colorWithHexString:@"#FFEECC"];
            self.infoColor = [UIColor colorWithWhite:0 alpha:1];
            self.iconIsHidden = NO;
            self.icon.text = @"\U0000e91c";
            self.icon.textColor = [UIColor colorWithHexString:@"#FF9900"];
            break;
        case VENoticeBarStyleSuccess:
            self.bgColor = [UIColor colorWithHexString:@"#DDFFCC"];
            self.infoColor = [UIColor colorWithWhite:0 alpha:1];
            self.iconIsHidden = NO;
            self.icon.text = @"\U0000e91a";
            self.icon.textColor = [UIColor colorWithHexString:@"#00CC00"];
            break;
        default:
            self.bgColor = [UIColor colorWithHexString:@"#FFEACC"];
            self.infoColor = [UIColor colorWithHexString:@"#FA8900"];
            self.iconIsHidden = YES;
            break;
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setInfo:(NSString *)info {
    _info = info;
    self.infoLabel.text = info;
}

- (void)setInfoColor:(UIColor *)infoColor {
    _infoColor = infoColor;
    self.infoLabel.textColor = infoColor;
}

- (void)setInfoLines:(NSInteger)infoLines {
    _infoLines = infoLines;
    self.infoLabel.numberOfLines = infoLines;
}

- (void)setIconIsHidden:(BOOL)iconIsHidden {
    _iconIsHidden = iconIsHidden;
    self.icon.hidden = iconIsHidden;
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    self.moreBtn.hidden = !btnTitle.length;
    [self.moreBtn setTitle:btnTitle forState:UIControlStateNormal];
    self.closeIsHidden = !btnTitle.length;
    
    CGSize size = [self.moreBtn.titleLabel sizeThatFits:CGSizeMake(200, 23)];
    self.btnWidth = size.width + 21;
}

- (void)setCloseIsHidden:(BOOL)closeIsHidden {
    _closeIsHidden = closeIsHidden;
    self.close.hidden = closeIsHidden;
}


@end
