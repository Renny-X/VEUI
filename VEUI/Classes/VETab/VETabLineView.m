//
//  VETabLineView.m
//  VEUI
//
//  Created by Coder on 2021/4/20.
//

#import "VETabLineView.h"

@interface VETabLineView ()

@property(nonatomic, strong)UIView *lineView;

@end

@implementation VETabLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lineView = [[UIView alloc] init];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineView.frame = self.bounds;
    if (self.horizontalGap) {
        self.lineView.width = self.width - self.horizontalGap;
    }
    self.lineView.centerX = self.width * 0.5;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.lineView.backgroundColor = backgroundColor;
}

- (void)setHorizontalGap:(CGFloat)horizontalGap {
    _horizontalGap = horizontalGap;
    [self setNeedsLayout];
}

@end
