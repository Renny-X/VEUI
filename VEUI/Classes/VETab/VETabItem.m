//
//  VETabItem.m
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import "VETabItem.h"
#import <VEUI/VEUI.h>

@interface VETabItem ()

@property(nonatomic, strong)UILabel *label;

@property(nonatomic, strong)UIView *line;

@end

@implementation VETabItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;

    _style = VETabItemStyleShortLine;
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
    
    self.activeColor = [UIColor colorWithHexString:@"#09f"];
    self.inactiveColor = [UIColor colorWithHexString:@"#000"];
    self.titleFont = [UIFont systemFontOfSize:16];
    
    self.line = [[UIView alloc] init];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.font = self.titleFont;
    self.label.text = self.title;
    
    CGSize tmpSize = [self.label sizeThatFits:CGSizeMake(self.width, self.height)];
    self.label.frame = self.bounds;
    self.label.height -= self.lineHeight;
    self.label.textColor = self.selected ? self.activeColor : self.inactiveColor;
    
    switch (self.style) {
        case VETabItemStyleShortLine:
            self.line.frame = CGRectMake(0, self.height - self.lineHeight, tmpSize.width, self.lineHeight);
            break;
        case VETabItemStyleFullLine:
            self.line.frame = CGRectMake(0, self.height - self.lineHeight, self.label.width, self.lineHeight);
            break;
        default:
            self.line.frame = CGRectZero;
            break;
    }
    if (!self.selected) {
        self.line.frame = CGRectZero;
    }
    self.line.centerX = self.label.width * 0.5;
    self.line.backgroundColor = self.label.textColor;
}

#pragma mark - Get
- (CGFloat)lineHeight {
    if (!_lineHeight) {
        return 3;
    }
    return _lineHeight;
}

@end
