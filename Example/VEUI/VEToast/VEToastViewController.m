//
//  VEToastViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/2/23.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEToastViewController.h"

@interface VEToastViewController ()

@property(nonatomic, strong)NSArray *arr;

@property(nonatomic, strong)UICollectionView *colV;

@end

@implementation VEToastViewController

- (NSArray *)arr {
    if (!_arr) {
        _arr = @[
            @[
                @"Toast String", @"Toast Success", @"Toast Error",
            ], @[
                @"Loading",
            ], @[
                @"Toast Image", @"Loading Image",
            ],
        ];
    }
    return _arr;
}

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

//    [VEToast toast:@"aaaaaaa"];
//    [VEToast success:@"success"];
    [VEToast loading:@"loading"];
//    [VEToast loading:nil images:@[[UIImage imageNamed:@"refresh"]] animateDuration:2 mask:NO];
}

@end
