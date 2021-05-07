//
//  VETabItem.m
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import "VETabItem.h"
#import <VEUI/VEUI.h>

@interface VETabItem ()

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
    _label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
    
    self.activeColor = [UIColor colorWithHexString:@"#09f"];
    self.inactiveColor = [UIColor colorWithHexString:@"#000"];
    self.activeFontSize = 16;
    self.inactiveFontSize = 16;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.font = [self getFont];
    self.label.text = self.title;
    self.label.frame = self.bounds;
    self.label.textColor = [UIColor colorFromColor:self.inactiveColor toColor:self.activeColor progress:self.selectProgress];
}

#pragma mark - Set
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!selected) {
        self.selectProgress = 0;
    }
    [self setNeedsLayout];
}

#pragma mark - Get
- (UIFont *)getFont {
    CGFloat fontSize = self.inactiveFontSize * (1 - self.selectProgress) + self.activeFontSize * self.selectProgress;
    if (self.fontName) {
        return [UIFont fontWithName:self.fontName size:fontSize];
    }
    return [UIFont systemFontOfSize:fontSize];
}

@synthesize textWidth = _textWidth;
- (CGFloat)textWidth {
    if (!_textWidth) {
        CGRect rect = [self.title boundingRectWithSize:CGSizeMake(self.width, self.height) options:0 attributes:@{
            NSFontAttributeName:self.fontName ? [UIFont fontWithName:self.fontName size:self.activeFontSize] : [UIFont systemFontOfSize:self.activeFontSize]
        } context:nil];
        _textWidth = rect.size.width;
    }
    return _textWidth;
}

@end
