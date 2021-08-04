//
//  VEUITabbarCategoryController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/10.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUITabbarCategoryController.h"

@interface VEUITabbarCategoryController ()<UITabBarControllerDelegate>

@property(nonatomic, strong)NSArray<UIImage *> *animateImages;

@end

@implementation VEUITabbarCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self addChildViewController:[UIViewController new] title:@"vc1" normalImage:[UIImage imageNamed:@"refresh"]];
    [self addChildViewController:[UIViewController new] title:@"vc2" normalImage:[UIImage imageNamed:@"refresh"]];
    [self addChildViewController:[UIViewController new] title:@"vc3" normalImage:[UIImage imageNamed:@"refresh_1"]];
    [self addChildViewController:[UIViewController new] title:@"vc4" normalImage:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSLog(@"==> ==> ==> ==> ==> ==> ==> ==> ==>");
    NSLog(@"last ==> %ld", self.lastSelectedIndex);
    NSLog(@"curl ==> %ld", self.selectedIndex);
    
    viewController.tabBarItem.showBadgeDot = !viewController.tabBarItem.showBadgeDot;
    viewController.tabBarItem.badgeDotWidth = 25;
    
    if ([viewController.tabBarItem.title isEqualToString:@"vc1"]) {
        viewController.tabBarItem.showBadgeDot = YES;
        viewController.tabBarItem.badgeValue = viewController.tabBarItem.badgeValue == nil ? @"22" : nil;
    }
    
    if ([viewController.tabBarItem.title isEqualToString:@"vc3"]) {
        viewController.tabBarItem.badgeDotWidth = 8;
        [viewController.tabBarItem animateWithImages:self.animateImages duration:29.0 / 24.0];
    }
}

- (NSArray<UIImage *> *)animateImages {
    if (!_animateImages) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 1; i < 30; i++) {
            [tmp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_%d", i]]];
        }
        _animateImages = [tmp copy];
    }
    return _animateImages;
}

- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title normalImage:(UIImage *)img {
    vc.view.backgroundColor = [UIColor randomColor];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = img;
    vc.tabBarItem.selectedImage = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:vc];
}

@end
