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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
    label.backgroundColor = [UIColor colorWithHexString:@"#000"];
    
    [self.view addSubview:label];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
