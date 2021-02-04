//
//  VEUIViewController.m
//  VEUI
//
//  Created by Coder on 02/01/2021.
//  Copyright (c) 2021 Coder. All rights reserved.
//

#import "VEUIViewController.h"

@interface VEUIViewController ()

@end

@implementation VEUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    VELabel *label = [[VELabel alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
    label.backgroundColor = [UIColor colorWithHexString:@"#f00"];
    label.textColor = [UIColor colorWithHexString:@"#fff"];
    label.text = @"asdfasdfasdf";
    label.edgeInsets = UIEdgeInsetsMake(10, 20, 2, 5);
    label.textVerticalAlignment = VELabelTextVerticalAlignmentTop;
    
    [self.view addSubview:label];
    
    NSDictionary *dict = @{
        @"键1": @[@"值1", [NSNull null], @{
                     @"数组键1": @"数组值1", @"数组键2": [NSNull null], @"数组键3": @[@"11", [NSNull null], @"22"]
        }],
    };
    NSArray *arr = @[@"数组1", [NSNull null], dict];
    
//    NSLog(@"%@", arr);
//    NSLog(@"%@", [arr formatValue]);
    
//    NSLog(@"%@", [dict stringValueForKey:@"键1"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
