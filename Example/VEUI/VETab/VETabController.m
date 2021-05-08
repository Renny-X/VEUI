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

//#import "UINavigationController+FDFullscreenPopGesture.h"

@interface VETabController ()<VETabDelegate, VETabDataSource>

@property(nonatomic, strong)UIView *testView;
@property(nonatomic, strong)VETab *tab;
@property(nonatomic, strong)NSArray *randomWidth;

@end

@implementation VETabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    VETab *tab = [[VETab alloc] initWithStyle:VETabStyleLineEqual];
//    VETab *tab = [[VETab alloc] initWithStyle:VETabStyleDefault];
    tab.frame = CGRectMake(100, 100, self.view.width, 100);
    tab.backgroundColor = [UIColor whiteColor];
    tab.delegate = self;
    tab.dataSource = self;
//    tab.tabScrollEnabled = YES;
//    tab.contentScrollEnabled = NO;
    tab.tabVerticalGap = 15;
    tab.tabItemGap = 30;
    self.tab = tab;
    [self.view addSubview:tab];
    
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
    return self.randomWidth.count;
}

- (CGFloat)tab:(VETab *)tab tabItemWidthAtIndex:(NSInteger)index {
    if (index == 0) {
        return 150;
    }
    return [self.randomWidth[index] floatValue];
}

- (__kindof VETabItem *)tab:(VETab *)tab tabItemAtIndex:(NSInteger)index {
    VETabItem *tabItem = [tab tabItemAtIndex:index];
    tabItem.title = [NSString stringWithFormat:@"标题 %d", (int)index];
    tabItem.activeColor = [UIColor colorWithHexString:@"#09f"];
    tabItem.inactiveFontSize = 14;
    tabItem.activeFontSize = 16;
    if (index == 0) {
        tabItem.title = [NSString stringWithFormat:@"%@ - %@", tabItem.title, [NSDate dateStringWithFormatter:@"HH:mm:ss"]];
        tabItem.activeColor = [UIColor colorWithHexString:@"#f90"];
        return tabItem;
    }
    return tabItem;
}

- (UIView *)tab:(VETab *)tab contentViewAtIndex:(NSInteger)index {
    VETabContentView *v = [[VETabContentView alloc] init];
    v.backgroundColor = [UIColor randomColor];
    __weak typeof(self) ws = self;
    v.clickBack = ^(BOOL begin) {
        [ws tapAction];
    };
    return v;
}

- (void)didSelectAtIndex:(NSInteger)index {
}

- (void)tapAction {
    [self.tab reloadTab];
//    [self.tab setSelectedIndex:randomNum(0, (int)self.randomWidth.count - 1) animated:randomNum(0, 1)];
}

@end
