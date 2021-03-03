//
//  VEImageBrowserViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/2/25.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEImageBrowserViewController.h"

@interface VEImageBrowserViewController ()

@end

@implementation VEImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    btn.backgroundColor = UIColor.greenColor;
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.center = CGPointMake(self.view.centerX, self.view.height - 100);
    // Do any additional setup after loading the view.
}

- (void)btnClicked {
    VEImageBrowserModel *model0 = [[VEImageBrowserModel alloc] initWithImage:[UIImage imageNamed:@"refresh"] originFrame:CGRectZero];
    VEImageBrowserModel *model1 = [[VEImageBrowserModel alloc] initWithImage:[UIImage imageNamed:@"refresh"] originFrame:CGRectMake(0, 0, 50, 50)];
    VEImageBrowserModel *model2 = [[VEImageBrowserModel alloc] initWithImage:[UIImage imageNamed:@"refresh"] originFrame:CGRectMake(90, 200, 100, 190)];
    VEImageBrowser *ib = [[VEImageBrowser alloc] initWithModelArray:@[model0, model1, model2]];
//    VEImageBrowser *ib = [[VEImageBrowser alloc] initWithImageArray:@[[UIImage imageNamed:@"refresh"], [UIImage imageNamed:@"refresh"]]];
    
    [ib show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
