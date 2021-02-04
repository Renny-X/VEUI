//
//  VELabel.m
//  VEUI
//
//  Created by Coder on 2021/2/3.
//

#import "VELabel.h"

@implementation VELabel

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initParams];
    }
    return self;
}

- (void)initParams {
    _edgeInsets = UIEdgeInsetsZero;
    _textVerticalAlignment = VELabelTextVerticalAlignmentDefault;
}

#pragma mark - draw rect
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    bounds.size.width -= self.edgeInsets.left + self.edgeInsets.right;
    bounds.size.height -= self.edgeInsets.top + self.edgeInsets.bottom;
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.textVerticalAlignment) {
        case VELabelTextVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VELabelTextVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
    }
    textRect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    textRect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    CGRect drawRect = UIEdgeInsetsInsetRect(textRect, self.edgeInsets);
    [super drawTextInRect:drawRect];
}

#pragma mark - over write
- (void)sizeToFit {
    [super sizeToFit];
    CGSize size = CGSizeMake(self.frame.size.width + _edgeInsets.left + _edgeInsets.right, self.frame.size.height + _edgeInsets.top + _edgeInsets.bottom);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize tmpSize = [super sizeThatFits:size];
    tmpSize = CGSizeMake(tmpSize.width + _edgeInsets.left + _edgeInsets.right, tmpSize.height + _edgeInsets.top + _edgeInsets.bottom);
    return tmpSize;
}

#pragma mark - public func
- (void)setTextVerticalAlignment:(VELabelTextVerticalAlignment)textVerticalAlignment {
    _textVerticalAlignment = textVerticalAlignment;
    [self setNeedsDisplay];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self setNeedsDisplay];
}

- (CGFloat)suggestWidth {
    return [self sizeThatFits:self.frame.size].width;
}

@end
