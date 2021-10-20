//
//  VEUIViewCategoryViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/10/20.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUIViewCategoryViewController.h"

@interface VEUIViewCategoryViewController ()

@property(nonatomic, strong)UIView *backView;
@property(nonatomic, strong)UIView *targetView;

@end

@implementation VEUIViewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = UIColor.randomColor;
    [self.backView addCornerRadius:12];
    [self.view addSubview:self.backView];
    
    self.targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.targetView.backgroundColor = UIColor.randomColor;
    [self.targetView addCornerRadius:12 toCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
    self.targetView.clipsToBounds = YES;
    [self.view addSubview:self.targetView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.targetView.center = self.view.center;
    
    CGSize size = self.targetView.size;
    size.width += 20;
    size.height += 20;
    self.backView.size = size;
    self.backView.center = self.targetView.center;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    self.targetView.size = [self getRandomSize];
}

- (CGSize)getRandomSize {
    CGFloat width = (CGFloat)randomNum(2500, 30000) / 100.0;
    return CGSizeMake(width, width);
}

@end
