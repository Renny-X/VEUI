//
//  VEUIImageCategoryViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/5.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUIImageCategoryViewController.h"

@interface VEUIImageCategoryViewController ()

@property(nonatomic, strong)UIImageView *sourceImgV;
@property(nonatomic, strong)UIImageView *viewImgV;
@property(nonatomic, strong)UIImage *viewImage;

@end

@implementation VEUIImageCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    self.sourceImgV = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, self.view.width - 100, (self.view.height - 200 - 160) * 0.5)];
    self.sourceImgV.backgroundColor = [UIColor lightGrayColor];
    self.sourceImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.sourceImgV.image = [[UIImage imageNamed:@"test"] gaussianBlurImageWithBlurLevel:0.1];
    self.sourceImgV.clipsToBounds = YES;
//    [self.sourceImgV.layer setMasksToBounds:YES];
//    [self.sourceImgV.layer setCornerRadius:40];
    [self.view addSubview:self.sourceImgV];
    
    self.viewImgV = [self.sourceImgV concat];
    [self.viewImgV.layer setMasksToBounds:NO];
    self.viewImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.viewImgV.backgroundColor = UIColor.darkGrayColor;
    self.viewImgV.image = self.viewImage;
    self.viewImgV.y = self.sourceImgV.maxY + 20;
    [self.view addSubview:self.viewImgV];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    btn.center = CGPointMake(self.view.centerX, self.view.height - 150);
    btn.maxX = self.view.centerX - 10;
    btn.tag = 1001;
    btn.backgroundColor = UIColor.greenColor;
    [btn setTitle:@"imageView" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [btn concat];
    btn1.x = self.view.centerX + 10;
    btn1.tag = 1000;
    btn1.backgroundColor = UIColor.redColor;
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"self.view" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
}

- (void)btnClicked:(UIButton *)sender {
//    self.sourceImgV.hidden = YES;
    self.viewImage = sender.tag % 10 ? [[UIImage imageFromView:self.sourceImgV] resetTintColor:[UIColor greenColor]] : [UIImage imageFromView:self.view];
    self.viewImgV.image = self.viewImage;
}

@end
