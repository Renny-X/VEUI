//
//  VEUIAlertCategoryViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/29.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUIAlertCategoryViewController.h"

@interface VEUIAlertCategoryViewController ()

@end

@implementation VEUIAlertCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UIAlertController *alert = [UIAlertController alertWithTitle:@"title" message:@"message" leftTitle:@"cancel" leftTitleColor:[UIColor greenColor] rightTitle:@"sure" rightTitleColor:[UIColor lightGrayColor] leftAction:nil rightAction:^{
        [VEToast toast:@"this is a toast"];
    }];
    alert.titleColor = [UIColor yellowColor];
    alert.messageColor = [UIColor redColor];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
