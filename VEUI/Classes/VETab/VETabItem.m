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
//@property(nonatomic, strong)UILabel *activeLabel;

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
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
    
    self.activeColor = [UIColor colorWithHexString:@"#09f"];
    self.inactiveColor = [UIColor colorWithHexString:@"#000"];
    self.activeFont = [UIFont systemFontOfSize:16];
    self.inactiveFont = [UIFont systemFontOfSize:16];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.font = self.inactiveFont;
    self.label.text = self.title;
    self.label.frame = self.bounds;
    self.label.textColor = [UIColor colorFromColor:self.inactiveColor toColor:self.activeColor progress:self.selectProgress];
}

#pragma mark - Get

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!selected) {
        self.selectProgress = 0;
    }
    [self setNeedsLayout];
}

@end
