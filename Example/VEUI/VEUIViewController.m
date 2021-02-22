//
//  VEUIViewController.m
//  VEUI
//
//  Created by Coder on 02/01/2021.
//  Copyright (c) 2021 Coder. All rights reserved.
//

#import "VEUIViewController.h"

@interface VEUIViewController ()

@property(nonatomic, assign)NSInteger clickCount;

@end

@implementation VEUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    VELabel *label = [[VELabel alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
    label.backgroundColor = [UIColor colorWithHexString:@"#f00"];
    label.textColor = [UIColor colorWithHexString:@"#fff"];
    label.text = @"\U0000e902";
    label.font = [UIFont VEFontWithSize:17];
    label.edgeInsets = UIEdgeInsetsMake(10, 20, 2, 5);
    label.textVerticalAlignment = VELabelTextVerticalAlignmentBottom;
    [self.view addSubview:label];
    
    self.clickCount = 0;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    btn.center = CGPointMake(self.view.centerX, self.view.height - 120);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    NSDictionary *dict = @{
//        @"键1": @[@"值1", [NSNull null], @{
//                     @"数组键1": @"数组值1", @"数组键2": [NSNull null], @"数组键3": @[@"11", [NSNull null], @"22"]
//        }],
//    };
//    NSArray *arr = @[@"数组1", [NSNull null], dict];
//
//    NSLog(@"%@", [arr formatValue]);
//    NSLog(@"%@", [dict safeValueForKey:@"键1"]);
}

- (void)btnClicked:(UIButton *)sender {
//    [VEToast success:[NSString stringWithFormat:@"%ld 爱唯欧房间爱上大路口附近阿斯顿福建傲时代峻峰冷风机阿萨德咖啡机对方就暗示的路口附近老地方看见爱上了打开房间", (long)++self.clickCount] duration:5];
//    [VEToast toast:[NSString stringWithFormat:@"%ld 爱唯欧房间爱上大路口附近阿", (long)++self.clickCount]];
    [VEToast error:[NSString stringWithFormat:@"%ld 爱唯欧房间爱上大路口附近阿斯顿福建傲时代峻峰冷风机阿萨德咖啡机对方就暗示的路口附近老地方看见爱上了打开房间", (long)++self.clickCount] duration:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
