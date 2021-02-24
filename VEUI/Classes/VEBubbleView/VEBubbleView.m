//
//  VEBubbleView.m
//  Store
//
//  Created by Coder on 2021/1/12.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import "VEBubbleView.h"

@implementation VEBubbleView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initParams];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initParams];
    }
    return self;
}

- (void)initParams {
    self.cornerRadius = 5;
    self.arrowSize = CGSizeMake(15, 6);
    self.contentColor = [UIColor whiteColor];
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = UIColor.clearColor;
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGRect contentFrame;
    CGPoint aStart;
    CGPoint aNext;
    CGPoint aEnd;
    switch (self.position) {
        case VEBubbleContentPositionLeft:
            aStart = CGPointMake(rect.size.width + self.arrowOffset.x, center.y + self.arrowOffset.y);
            aNext = CGPointMake(aStart.x - self.arrowSize.height, aStart.y - self.arrowSize.width * 0.5);
            aEnd = CGPointMake(aNext.x, aNext.y + self.arrowSize.width);
            contentFrame = CGRectMake(0, 0, aEnd.x, rect.size.height);
            break;
        case VEBubbleContentPositionRight:
            aStart = CGPointMake(self.arrowOffset.x, center.y + self.arrowOffset.x);
            aNext = CGPointMake(aStart.x + self.arrowSize.height, aStart.y - self.arrowSize.width * 0.5);
            aEnd = CGPointMake(aNext.x, aNext.y + self.arrowSize.width);
            contentFrame = CGRectMake(aEnd.x, 0, rect.size.width - aEnd.x, rect.size.height);
            break;
        case VEBubbleContentPositionBottom:
            aStart = CGPointMake(center.x + self.arrowOffset.x,  + self.arrowOffset.y);
            aNext = CGPointMake(aStart.x - self.arrowSize.width * 0.5, aStart.y + self.arrowSize.height);
            aEnd = CGPointMake(aNext.x + self.arrowSize.width, aNext.y);
            contentFrame = CGRectMake(0, aEnd.y, rect.size.width, rect.size.height - aEnd.y);
            break;
        default:
            aStart = CGPointMake(center.x + self.arrowOffset.x, rect.size.height + self.arrowOffset.y);
            aNext = CGPointMake(aStart.x - self.arrowSize.width * 0.5, aStart.y - self.arrowSize.height);
            aEnd = CGPointMake(aNext.x + self.arrowSize.width, aNext.y);
            contentFrame = CGRectMake(0, 0, rect.size.width, aEnd.y);
            break;
    }
    
    // 绘制矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:contentFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    [self.contentColor setFill];
    [rectPath fill];
    [rectPath closePath];
    
    UIBezierPath *anglePath = [UIBezierPath bezierPath];
    [anglePath moveToPoint:aStart];
    [anglePath addLineToPoint:aNext];
    [anglePath addLineToPoint:aEnd];
    [anglePath addLineToPoint:aStart];
    [self.contentColor setFill];
    [anglePath fill];
    [anglePath closePath];
}

@end
