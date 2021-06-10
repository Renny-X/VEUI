//
//  VEUITabbarCategoryController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/10.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUITabbarCategoryController.h"

@interface VEUITabbarCategoryController ()<UITabBarControllerDelegate>

@end

@implementation VEUITabbarCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    UIViewController *vc1 = [UIViewController new];
    vc1.strTag = @"vc1";
    
    [self addChildViewController:vc1 title:@"vc1" normalImage:[UIImage imageNamed:@"refresh"]];
    [self addChildViewController:[UIViewController new] title:@"vc2" normalImage:[UIImage imageNamed:@"refresh"]];
    [self addChildViewController:[UIViewController new] title:@"vc3" normalImage:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    viewController.tabBarItem.showBadgeDot = !viewController.tabBarItem.showBadgeDot;
    viewController.tabBarItem.badgeDotWidth = 25;
    
    if ([viewController.strTag isEqualToString:@"vc1"]) {
        viewController.tabBarItem.badgeValue = @"";
    }
}

- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title normalImage:(UIImage *)img {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = img;
    
    [self addChildViewController:vc];
}

@end
