//
//  VETabContentItem.m
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import "VETabContentItem.h"

@implementation VETabContentItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutView = [[UIView alloc] init];
        [self.contentView addSubview:self.layoutView];
        self.layoutView.backgroundColor = UIColor.greenColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layoutView.frame = self.bounds;
}

- (void)setLayoutView:(UIView *)layoutView {
    _layoutView = layoutView;
    [self.contentView addSubview:_layoutView];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsLayout];
}

@end
