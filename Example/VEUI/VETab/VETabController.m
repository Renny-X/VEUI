//
//  VETabController.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/10.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VETabController.h"
#import <CoreText/CoreText.h>

@interface VETabController ()<VETabDelegate>

@property(nonatomic, strong)UIView *testView;

@end

@implementation VETabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    
    VETab *tab = [[VETab alloc] initWithTitles:@[@"aaa", @"bbb", @"ccc"]];
    tab.frame = CGRectMake(0, 100, self.view.width, 60);
    tab.backgroundColor = [UIColor whiteColor];
    tab.delegate = self;
    [self.view addSubview:tab];
//    [self test];
}

- (CGFloat)tabItemWidthAtIndex:(NSInteger)index title:(NSString *)title {
    return self.view.width / 3.0;
}

- (VETabItem *)tabItemAtIndex:(NSInteger)index title:(NSString *)title tabItem:(VETabItem *)tabItem {
    tabItem.style = VETabItemStyleFullLine;
    if (index == 0) {
        tabItem.activeColor = UIColor.redColor;
        return tabItem;
    }
    return tabItem;
}

- (void)didSelectAtIndex:(NSInteger)index {
    NSLog(@"%d", (int)index);
}

- (UIView *)tabContentViewAtIndex:(NSInteger)index {
    if (index == 1) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor yellowColor];
        return v;
    }
    return nil;
}


// 待用代码
- (void)test {
    //整体区域
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    
    //在整体区域上，镂空透明区域
//    CGRect rect = CGRectMake(100,100,100,100);

    //指定区域
//    UIBezierPath *clearPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    UIBezierPath *clearPath = [self transformToBezierPath:@"aaa测试字符串 dd fa ——_"];

    [bezierPath appendPath: clearPath];
    [bezierPath setUsesEvenOddFillRule:YES];

    //创建layer显示
    
    CAShapeLayer *layer = [CAShapeLayer layer];

    layer.path = bezierPath.CGPath;

    [layer setFillRule:kCAFillRuleEvenOdd];

    layer.opacity = 0.6;

    //添加到View上
//    [View.layer addSublayer:self.Layer];
    [self.view.layer addSublayer:layer];
}

- (UIBezierPath *)transformToBezierPath:(NSString *)string {
    CGMutablePathRef paths = CGPathCreateMutable();
    CFStringRef fontNameRef = CFSTR("SnellRoundhand");
    CTFontRef fontRef = CTFontCreateWithName(fontNameRef, 18, nil);
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{(__bridge NSString *)kCTFontAttributeName: (__bridge UIFont *)fontRef}];
    CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArrRef = CTLineGetGlyphRuns(lineRef);
    
    for (int runIndex = 0; runIndex < CFArrayGetCount(runArrRef); runIndex++) {
        const void *run = CFArrayGetValueAtIndex(runArrRef, runIndex);
        CTRunRef runb = (CTRunRef)run;
        
        const void *CTFontName = kCTFontAttributeName;
        
        const void *runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb), CTFontName);
        CTFontRef runFontS = (CTFontRef)runFontC;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        int temp = 0;
        CGFloat offset = .0;
        
        for (int i = 0; i < CTRunGetGlyphCount(runb); i++) {
            CFRange range = CFRangeMake(i, 1);
            CGGlyph glyph = 0;
            CTRunGetGlyphs(runb, range, &glyph);
            CGPoint position = CGPointZero;
            CTRunGetPositions(runb, range, &position);
            
            CGFloat temp3 = position.x;
            int temp2 = (int)temp3/width;
            CGFloat temp1 = 0;
            
            if (temp2 > temp1) {
                temp = temp2;
                offset = position.x - (CGFloat)temp;
            }
            
            CGPathRef path = CTFontCreatePathForGlyph(runFontS, glyph, nil);
            CGFloat x = position.x - (CGFloat)temp*width - offset;
            CGFloat y = position.y - (CGFloat)temp * 80;
            CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
            CGPathAddPath(paths, &transform, path);
            
            CGPathRelease(path);
        }
        CFRelease(runb);
        CFRelease(runFontS);
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
    
    CGPathRelease(paths);
    CFRelease(fontNameRef);
    CFRelease(fontRef);
    
    return bezierPath;
}

@end
