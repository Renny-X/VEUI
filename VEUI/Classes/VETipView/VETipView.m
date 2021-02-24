//
//  VETipView.m
//  Store
//
//  Created by Coder on 2021/1/6.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import "VETipView.h"

@interface VETipView()

@property(nonatomic, assign)CGRect focusViewLocalFrame;
@property(nonatomic, assign)CGRect containerViewLocalFrame;

@property(nonatomic, assign)CGRect bubbleFrame;

// 四周留空区域高度
@property(nonatomic, assign)UIEdgeInsets gapArea;

@end

@implementation VETipView

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentGap = 2;
        _contentSize = CGSizeZero;
        _direction = VETipDirectionAuto;
    }
    return self;
}

- (instancetype)initWithFocusView:(UIView * _Nonnull)focusView
                      contentSize:(CGSize)contentSize {
    self = [self init];
    self.contentSize = contentSize;
    self.focusView = focusView;
    return self;
}

- (instancetype)initWithFocusView:(UIView * _Nonnull)focusView
                      contentSize:(CGSize)contentSize
                        direction:(VETipDirection)direction {
    self = [self initWithFocusView:focusView contentSize:contentSize];
    self.direction = direction;
    return self;
}

- (void)show {
    switch (self.contentPosition) {
        case VETipContentPositionLeft:
            self.bubble.position = VEBubbleContentPositionLeft;
            break;
        case VETipContentPositionRight:
            self.bubble.position = VEBubbleContentPositionRight;
            break;
        case VETipContentPositionBottom:
            self.bubble.position = VEBubbleContentPositionBottom;
            break;
        default:
            self.bubble.position = VEBubbleContentPositionTop;
            break;
    }
    self.bubble.frame = self.bubbleFrame;
    [self.bubble setNeedsDisplay];
    [self addSubview:self.bubble];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
}

#pragma mark - Set Func
- (void)setFocusView:(UIView *)focusView {
    _focusView = focusView;
    if (focusView) {
        self.focusViewLocalFrame = [focusView convertRect:focusView.bounds toView:nil];
    }
}

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    if (containerView) {
        self.containerViewLocalFrame = [containerView convertRect:containerView.bounds toView:nil];
    }
}

#pragma mark - Get Func
- (VETipContentPosition)contentPosition {
    if (_contentPosition != VETipContentPositionUnknown) {
        return _contentPosition;
    }
    if (!self.focusView || !self.focusView.superview || CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        return VETipContentPositionTop;
    }
    
    float vertical = self.bubble.arrowSize.height + self.contentSize.height + self.contentGap;
    float horizontal = self.bubble.arrowSize.height + self.contentSize.width + self.contentGap;
    
    switch (self.direction) {
        case VETipDirectionAuto: {
            if (vertical <= self.gapArea.top) {
                return VETipContentPositionTop;
            } else if (vertical <= self.gapArea.bottom) {
                return VETipContentPositionBottom;
            } else if (horizontal <= self.gapArea.right) {
                return VETipContentPositionRight;
            } else if (horizontal <= self.gapArea.left) {
                return VETipContentPositionLeft;
            }
            return VETipContentPositionTop;
        }
        case VETipDirectionVertical: {
            float tmpTop = self.gapArea.top - vertical;
            float tmpBottom = self.gapArea.bottom - vertical;
            if (tmpTop >= 0 || (tmpBottom < 0 && tmpBottom <= tmpTop)) {
                return VETipContentPositionTop;
            }
            return VETipContentPositionBottom;
        }
        case VETipDirectionHorizontal: {
            float tmpRight = self.gapArea.right - horizontal;
            float tmpLeft = self.gapArea.left - horizontal;
            if (tmpRight >= 0) {
                return VETipContentPositionRight;
            } else if (tmpLeft >= 0 || tmpLeft > tmpRight) {
                return VETipContentPositionLeft;
            }
            return VETipContentPositionRight;
        }
        default:
            return VETipContentPositionTop;
    }
}

- (UIEdgeInsets)gapArea {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = self.focusViewLocalFrame.origin.y - self.containerViewLocalFrame.origin.y;
    insets.left = self.focusViewLocalFrame.origin.x - self.containerViewLocalFrame.origin.x;
    insets.bottom = CGRectGetMaxY(self.containerViewLocalFrame) - CGRectGetMaxY(self.focusViewLocalFrame);
    insets.right = CGRectGetMaxY(self.containerViewLocalFrame) - CGRectGetMaxX(self.focusViewLocalFrame);
    return insets;
}

- (CGRect)containerViewLocalFrame {
    if (CGRectEqualToRect(_containerViewLocalFrame, CGRectZero)) {
        return [UIApplication sharedApplication].keyWindow.bounds;
    }
    return _containerViewLocalFrame;
}

- (CGRect)bubbleFrame {
    CGRect frame = CGRectZero;
    CGPoint center = CGPointMake(self.focusViewLocalFrame.origin.x + self.focusViewLocalFrame.size.width * 0.5, self.focusViewLocalFrame.origin.y + self.focusViewLocalFrame.size.height * 0.5);
    CGFloat tmp = 0;
    switch (self.contentPosition) {
        case VETipContentPositionLeft:
            tmp = self.contentSize.width + self.bubble.arrowSize.height;
            frame = CGRectMake(self.focusViewLocalFrame.origin.x - tmp - self.contentGap, center.y - self.contentSize.height * 0.5, tmp, self.contentSize.height);
            break;
        case VETipContentPositionRight:
            tmp = self.contentSize.width + self.bubble.arrowSize.height;
            frame = CGRectMake(CGRectGetMaxX(self.focusViewLocalFrame) + self.contentGap, center.y - self.contentSize.height * 0.5, tmp, self.contentSize.height);
            break;
        case VETipContentPositionTop:
            tmp = self.contentSize.height + self.bubble.arrowSize.height;
            frame = CGRectMake(center.x - self.contentSize.width * 0.5, self.focusViewLocalFrame.origin.y - tmp - self.contentGap, self.contentSize.width, tmp);
            break;
        default:
            // bottom
            tmp = self.contentSize.height + self.bubble.arrowSize.height;
            frame = CGRectMake(center.x - self.contentSize.width * 0.5, CGRectGetMaxY(self.focusViewLocalFrame) + self.contentGap, self.contentSize.width, tmp);
            break;
    }
    return frame;
}

- (VEBubbleView *)bubble {
    if (!_bubble) {
        _bubble = [[VEBubbleView alloc] init];
    }
    return _bubble;
}

#pragma mark - User Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:self];
    CGRect tmpBubbleFrame = self.bubbleFrame;
    BOOL isContain = point.x >= tmpBubbleFrame.origin.x
        && point.x <= tmpBubbleFrame.origin.x + tmpBubbleFrame.size.width
        && point.y >= tmpBubbleFrame.origin.y
        && point.y <= tmpBubbleFrame.origin.y + tmpBubbleFrame.size.height;
    if (!isContain) {
        [self hide];
    }
}

@end
