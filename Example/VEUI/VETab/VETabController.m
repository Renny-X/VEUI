//
//  VETabController.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/10.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VETabController.h"
#import <CoreText/CoreText.h>
#import "VETabContentView.h"

@interface VETabController ()<VETabDelegate, VETabDataSource>

@property(nonatomic, strong)UIView *testView;
@property(nonatomic, strong)VETab *tab;
@property(nonatomic, strong)NSArray *randomWidth;

@end

@implementation VETabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    
    VETab *tab = [[VETab alloc] initWithStyle:VETabStyleDefault];
    tab.frame = CGRectMake(100, 100, self.view.width, 100);
    tab.backgroundColor = [UIColor whiteColor];
    tab.delegate = self;
    tab.dataSource = self;
    tab.tabScrollEnabled = YES;
    self.tab = tab;
    [self.view addSubview:tab];
//    [self test];
    
    self.randomWidth = @[
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
        [NSNumber numberWithInt:randomNum(20, 110)],
    ];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tab.frame = self.view.bounds;
}

- (NSInteger)numberOfTabItems {
//    return 10;
    return self.randomWidth.count;
}

- (CGFloat)tab:(VETab *)tab tabItemWidthAtIndex:(NSInteger)index {
//    if (index == 1) {
//        return 60;
//    }
//    return self.view.width / 2.4;
    return [self.randomWidth[index] floatValue];
}

- (__kindof VETabItem *)tab:(VETab *)tab tabItemAtIndex:(NSInteger)index {
    VETabItem *tabItem = [tab tabItemAtIndex:index];
    tabItem.title = [NSString stringWithFormat:@"标题 %d", (int)index];
    tabItem.activeColor = [UIColor colorWithHexString:@"#09f"];
    if (index == 0) {
        tabItem.title = [NSString stringWithFormat:@"%@ - %@", tabItem.title, [NSDate dateStringWithFormatter:@"HH:mm:ss"]];
        tabItem.activeColor = [UIColor colorWithHexString:@"#f90"];
        return tabItem;
    }
    return tabItem;
}

- (UIView *)tab:(VETab *)tab contentViewAtIndex:(NSInteger)index {
    VETabContentView *v = [[VETabContentView alloc] init];
    switch (index) {
        case 0:
            v.backgroundColor = [UIColor redColor];
            break;
        case 1:
            v.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            v.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    v.backgroundColor = [UIColor randomColor];
    __weak typeof(self) ws = self;
    v.clickBack = ^(BOOL begin) {
        [ws tapAction];
    };
    return v;
}

- (void)didSelectAtIndex:(NSInteger)index {
    NSLog(@"%d", (int)index);
}

- (void)tapAction {
//    self.tab.contentScrollEnabled = !self.tab.contentScrollEnabled;
//    [self.tab reloadTab];
    [self.tab setSelectedIndex:randomNum(0, self.randomWidth.count - 1) animated:randomNum(0, 1)];
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
