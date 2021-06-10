//
//  UIView+VEUI.m
//  Store
//
//  Created by Coder on 2021/1/12.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import "UIView+VEUI.h"
#import "NSObject+VEUI.h"
#import <objc/runtime.h>

@implementation UIView (VEUI)

- (UIViewController *)viewController {
    for(UIView *next = self.superview; next; next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (id)concat {
    NSData *tmpData = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tmpData];
}

- (nullable UIView *)viewWithStrTag:(nullable NSString *)strTag{
    for (UIView *tempView in self.subviews) {
        if ([tempView.strTag isEqualToString:strTag]) {
            return tempView;
        }
    }
    return nil;
}

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)addToSuperView:(UIView *)superView {
    [superView addSubview:self];
}

- (void)addCornerRadius:(CGFloat)radius {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}

- (void)addCornerRadius:(CGFloat)radius toCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - set
- (void)setOrign:(CGPoint)orign{
    CGRect tempFrame = self.frame;
    tempFrame.origin = orign;
    self.frame = tempFrame;
}

- (void)setX:(CGFloat)x {
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}
- (void)setLeft:(CGFloat)left{
    self.x = left;
}

- (void)setY:(CGFloat)y {
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}
- (void)setTop:(CGFloat)top {
    self.y = top;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint tempPoint = self.center;
    tempPoint.x = centerX;
    self.center = tempPoint;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint tempPoint = self.center;
    tempPoint.y = centerY;
    self.center = tempPoint;
}

- (void)setSize:(CGSize)size{
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

- (void)setWidth:(CGFloat)width{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (void)setHeight:(CGFloat)height{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (void)setMaxX:(CGFloat)maxX{
    self.frame = CGRectMake(maxX - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (void)setRight:(CGFloat)right {
    self.maxX = right;
}

- (void)setMaxY:(CGFloat)maxY{
    self.frame = CGRectMake(self.frame.origin.x, maxY - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}
- (void)setBottom:(CGFloat)bottom {
    self.maxY = bottom;
}


#pragma mark - get
- (CGPoint)orign{
    return self.frame.origin;
}

- (CGFloat)x{
    return self.frame.origin.x;
}
- (CGFloat)left {
    return self.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)top {
    return self.y;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)maxX{
    return self.frame.size.width + self.frame.origin.x;
}
- (CGFloat)right {
    return self.maxX;
}

- (CGFloat)maxY{
    return self.frame.size.height + self.frame.origin.y;
}
- (CGFloat)bottom {
    return self.maxY;
}

@end
