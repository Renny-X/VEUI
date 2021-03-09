//
//  VEPopoverViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/8.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEPopoverViewController.h"

@interface VEPopoverViewController ()

@end

@implementation VEPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    btn.backgroundColor = UIColor.greenColor;
    btn.centerX = self.view.centerX;
    btn.maxY = self.view.height - 100;
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClicked {
    VEPopover *vc = [[VEPopover alloc] init];
    vc.contentAnimationStyle = VEPopoverContentAnimationStyleFromBottom;
    vc.contentPosition = VEPopoverContentPositionTop;
    vc.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    vc.contentView.backgroundColor = [UIColor greenColor];
    [vc show];
    vc.tapToHide = YES;
}

@end